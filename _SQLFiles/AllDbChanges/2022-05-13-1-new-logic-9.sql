use Broker_Commission;
go
-- auto-generated definition
create index INVOICE_NUM
    on SENT_INVOICE (INVOICE_NUM)
go
create index month
    on SENT_INVOICE (month)
go
create index year
    on SENT_INVOICE (year)
go


-- auto-generated definition
create index INVOICE_NUM
    on STATEMENT_DETAILS (INVOICE_NUM)
go


alter table STATEMENT_DETAILS
    drop column if exists TOTAL_PRICE_PAID_THIS_PERIOD
go

alter table dbo.STATEMENT_DETAILS_ARCHIVE
    drop column if exists TOTAL_PRICE_PAID_THIS_PERIOD
go

create
    function get_total_processed_this_period_NOTGOOD(
    @header_id int ) returns numeric(18, 2) as
begin
    declare @amount numeric;
    --      total both [COMMISSION_PAID] + [OPEN_BALANCE] as that would be waht we sent out for the poeriod in question
    select
        @amount = sum( TOTAL_PRICE )
    from
        [dbo].[STATEMENT_DETAILS]
    where
          HEADER_ID = @header_id
      and line_payment_status = 'paid';
    
    return isnull( @amount , 0 );
end
go


create or
alter
    function get_total_processed_this_period(
    @header_id int ) returns numeric(18, 2) as
begin
    declare @amount numeric;
    --      total both [COMMISSION_PAID] + [OPEN_BALANCE] as that would be waht we sent out for the poeriod in question
    select
            @amount = sum( dbo.get_invoice_sent_total_processed_this_period( INVOICE_NUM , month , year ) )
    from
        [dbo].[STATEMENT_DETAILS]
    where
        HEADER_ID = @header_id;
    
    return isnull( @amount , 0 );
end
go

create or
alter
    function get_invoice_sent_total_processed_this_period(
                                                         @invNum nvarchar(500),
                                                         @month varchar(50),
                                                         @year int ) returns numeric(18, 2) as
begin
    declare @amount numeric;
    --      total both [COMMISSION_PAID] + [OPEN_BALANCE] as that would be waht we sent out for the poeriod in question
    select
        @amount = sum( [COMMISSION_PAID] + [OPEN_BALANCE] )
    from
        [dbo].[SENT_INVOICE]
    where
          INVOICE_NUM_FORMATTED = rtrim( ltrim( upper( @invNum ) ) )
      and month = @month
      and year = @year;
    
    return isnull( @amount , 0 );
end
go

create or
alter function format_field( @value varchar(max) ) returns varchar(max)
as
begin
    return REPLACE(
            REPLACE(
                    REPLACE(
                            REPLACE(
                                    REPLACE(
                                            REPLACE(
                                                    LTRIM(
                                                            RTRIM(
                                                                    UPPER(
                                                                            isnull( @value , '' ) )
                                                                )
                                                        ) , '&' , '' ) ,
                                            ',' , '' ) ,
                                    '.' , '' ) ,
                            ' - ' , '-' ) ,
                    '- ' , '-' ) ,
            '-' , '' )
end
go
create or
alter PROCEDURE [dbo].[SP_IMPORT_FILE_SENT_SSIS]
@month nvarchar(30),
@year int
AS
BEGIN
    /* 0. check args are valid*/
    /* 0. check args are valid*/
    if isnull( @month , '' ) = ''
        begin
            THROW 51000, 'Month Cannot be Empty', 1;
        end
    
    if isnull( @year , 0 ) = 0
        begin
            THROW 51000, 'Year Cannot be Empty', 1;
        end
    
    set @month = dbo.format_field( @month );
    
    /*1. update current statement month and year in imported data for archival purposes*/
    update dbo.Import_OCT
    set
        statement_year  = @Year,
        statement_month = @Month,
        [Sales Price]   = isnull( [Sales Price] , 0 ),
        [Amount]        = isnull( [Amount] , 0 ),
        [Open Balance]  = isnull( [Open Balance] , 0 ),
        [Qty]           = isnull( [Qty] , 0 ),
        Num             = dbo.format_field( num ),
        Name= dbo.format_field( name ),
        Agent= dbo.format_field( Agent ),
        Memo= dbo.format_field( Memo ),
        is_deleted      =0;
    
    /* 2. receate Import-Archive for passed month and year */
    delete
    from
        dbo.Import_Archive
    where
          statement_month = @Month
      and statement_year = @Year;
    
    --     insert new records into import_archive
    insert into dbo.Import_Archive (
                                   ID,
                                   Type,
                                   Date,
                                   Num,
                                   Name,
                                   Memo,
                                   Agent,
                                   Qty,
                                   [Sales Price],
                                   Amount,
                                   [Open Balance],
                                   NUM_FORMATTED,
                                   memo_FORMATTED,
                                   Agent_FORMATTED,
                                   Name_FORMATTED,
                                   created_at,
                                   statement_month,
                                   statement_year,
                                   is_deleted
    )
    select
        ID
      , Type
      , Date
      , Num
      , Name
      , Memo
      , Agent
      , Qty
      , [Sales Price]
      , Amount
      , [Open Balance]
      , NUM_FORMATTED
      , memo_FORMATTED
      , Agent_FORMATTED
      , Name_FORMATTED
      , created_at
      , statement_month
      , statement_year
      , is_deleted
    from
        dbo.Import_OCT
    where
          statement_month = @Month
      and statement_year = @Year;
    
    /* 3. clear current statements header and details - DONT truncate so we opreserve header id over month by month iterations*/
    -- delete first curent statement details due to FK
    DELETE
    FROM
        [dbo].[STATEMENT_DETAILS];
    
    -- delete curent statement header
    DELETE
    FROM
        [dbo].[STATEMENT_HEADER];
    
    /* 4. generate new statements header and details fr om imported data joiniong imported data agent witgh various possible broker names in master */
    -- create distinct statement header
    INSERT INTO [dbo].[STATEMENT_HEADER]
    (
    [MONTH],
    [YEAR],
    [BROKER_ID],
    [BROKER_NAME],
    [FLAG],
    [Change_Date],
    PAYLOCITY_ID
    )
    SELECT
        @Month
      , @Year
      , RT.[BROKER_ID]
      , RT.[BROKER_NAME]
      , 0
      , getdate( )
      , RT.PAYLOCITY_ID
    FROM
        [dbo].[COMMISSION_RESULT] AS RT
    WHERE
          isnull( RT.[BROKER_NAME] , '' ) != ''
      AND isnull( RT.BROKER_ID , '' ) != ''
    GROUP BY
        RT.[BROKER_ID]
      , RT.[BROKER_NAME]
      , RT.PAYLOCITY_ID;
    
    -- create distinct statement details
    INSERT INTO [dbo].[STATEMENT_DETAILS]
    (
        [HEADER_ID]
    ,   [QB_CLIENT_NAME]
    ,   [CLIENT_NAME]
    ,   [BROKER_ID]
    ,   [BROKER_NAME]
    ,   [QB_FEE]
    ,   [FEE_MEMO]
    ,   [QUANTITY]
    ,   [COMMISSION_RATE]
    ,   [UNIT]
    ,   [SALES_PRICE]
    ,   [TOTAL_PRICE]
    ,   [START_DATE]
    ,   [STATUS]
    ,   [BROKER_STATUS]
    ,   [OPEN_BALANCE]
    ,   [INVOICE_NUM]
    ,   [INVOICE_DATE]
    ,   month
    ,   year
    )
    SELECT
        header.HEADER_ID
      , R.[QB_CLIENT]
      , R.[CLIENT_NAME]
      , R.[BROKER_ID]
      , R.[BROKER_NAME]
      , R.[QB_FEE]
      , R.[MEMO]
      , R.[Qty]
      , R.[COMMISSION_RATE]
      , R.[UNIT]
      , R.[Sales Price]
      , R.[COMMISSION AMOUNT]
      , R.[START_DATE]
      , R.[PAYLOCITY_ID]
      , R.[BROKER_STATUS]
      , R.[Open Balance]
      , RTRIM( LTRIM( R.[Num] ) )
      , [INVOICE_DATE]
      , HEADER.MONTH
      , HEADER.YEAR
    FROM
        [dbo].[STATEMENT_HEADER] AS HEADER
            LEFT JOIN [dbo].[COMMISSION_RESULT] AS R ON HEADER.[BROKER_ID] = R.[BROKER_ID]
    WHERE
          month = @Month
      and year = @Year;
    
    /* recalc totals*/
    exec SP_UPDATE_STATEMENT_PAYMENT_STATUS @month, @year;

END
go

create or
alter procedure SP_UPDATE_STATEMENT_PAYMENT_STATUS
@month nvarchar(30),
@year int
as
begin
    
    /* this does not truncate statements and reimport from Import_OCT - it just recalculates totals after emailing statements by checking against snet_invoices*/
    
    /* 5. RUN logic to set paid, pending and already paid and update header with stastement wise totals for display to the user and lookback */
    /* VERY IMPORTANT: It is this SP that marks each statement detail line_payment_status as paid, pending, or already paid*/
    /* run sp that will update line payment status based on open_balance and sent_invoices*/
    exec SP_CALC_STATEMENT_LINE_PAYMENT_STATUS @month , @year;
    
    /* 5. Now archive these generated statements */
    -- delete from statement details archive
    delete
    from
        [dbo].[STATEMENT_DETAILS_ARCHIVE]
    where
          month = @Month
      and year = @Year;
    
    -- delete from statement header archive
    delete
    from
        [dbo].[STATEMENT_HEADER_ARCHIVE]
    where
          month = @Month
      and year = @Year;
    
    -- insert into statement header archive
    INSERT INTO [dbo].[STATEMENT_HEADER_ARCHIVE](
                                                HEADER_ID,
                                                MONTH,
                                                YEAR,
                                                BROKER_ID,
                                                BROKER_NAME,
                                                FLAG,
                                                STATEMENT_TOTAL,
                                                STATEMENT_PENDING_TOTAL,
                                                STATEMENT_ALREADY_PAID_TOTAL,
                                                STATEMENT_PROCESSED_THIS_PERIOD,
                                                TOTAL,
                                                PAYLOCITY_ID,
                                                Change_Date
    )
    SELECT
        HEADER_ID
      , MONTH
      , YEAR
      , BROKER_ID
      , BROKER_NAME
      , FLAG
      , STATEMENT_TOTAL
      , STATEMENT_PENDING_TOTAL
      , STATEMENT_ALREADY_PAID_TOTAL
      , STATEMENT_PROCESSED_THIS_PERIOD
      , TOTAL
      , PAYLOCITY_ID
      , Change_Date
    FROM
        [dbo].[STATEMENT_HEADER]
    where
          month = @Month
      and year = @Year;
    
    -- insert into statement header archive
    INSERT INTO [dbo].[STATEMENT_DETAILS_ARCHIVE]
    (
    DETAIL_ID,
    HEADER_ID,
    INVOICE_DATE,
    INVOICE_NUM,
    QB_CLIENT_NAME,
    CLIENT_NAME,
    BROKER_ID,
    BROKER_NAME,
    QB_FEE,
    FEE_MEMO,
    QUANTITY,
    COMMISSION_RATE,
    UNIT,
    STATUS,
    SALES_PRICE,
    TOTAL_PRICE,
    START_DATE,
    BROKER_STATUS,
    OPEN_BALANCE,
    month,
    year,
    line_payment_status
    )
    SELECT
        DETAIL_ID
      , HEADER_ID
      , INVOICE_DATE
      , INVOICE_NUM
      , QB_CLIENT_NAME
      , CLIENT_NAME
      , BROKER_ID
      , BROKER_NAME
      , QB_FEE
      , FEE_MEMO
      , QUANTITY
      , COMMISSION_RATE
      , UNIT
      , STATUS
      , SALES_PRICE
      , TOTAL_PRICE
      , START_DATE
      , BROKER_STATUS
      , OPEN_BALANCE
      , month
      , year
      , line_payment_status
    FROM
        [dbo].[STATEMENT_DETAILS]
    where
          month = @Month
      and year = @Year;

end
go

create or
alter
    PROCEDURE [dbo].[SP_CALC_STATEMENT_LINE_PAYMENT_STATUS_FOR_HEADER]
@header_id int,
@broker_id int,
@client_name varchar(1000)
AS
BEGIN
    
    DECLARE @msg1 nvarchar(max)
    DECLARE @rowno int = 0
    DECLARE @continue int = 0
    /**/
    
    DECLARE @DETAIL_ID int;
    DECLARE @INVOICE_DATE datetime;
    DECLARE @INVOICE_NUM nvarchar(1000);
    DECLARE @OPEN_BALANCE numeric(18, 2);
    DECLARE @QB_FEE nvarchar(1000);
    DECLARE @NEW_LINE_STATUS nvarchar(100);
    DECLARE @PRV_INV_SENT_AMOUNT numeric(18, 2);
    DECLARE @YEAR int;
    DECLARE @MONTH varchar(50);
    
    SET @continue = 1
    
    DECLARE db_cursor2 CURSOR FOR
        SELECT
            DETAIL_ID
          , INVOICE_DATE
          , INVOICE_NUM
          , OPEN_BALANCE
          , QB_FEE
          , month
          , year
        FROM
            dbo.STATEMENT_DETAILS
        where
              HEADER_ID = @header_id
          and BROKER_ID = @broker_id
          and CLIENT_NAME = @client_name
        ORDER BY
            HEADER_ID
          , CLIENT_NAME
          , INVOICE_DATE
          , QB_FEE;
    
    --     EXEC db_log_message 'SP_CALC_STATEMENT_LINE_PAYMENT_STATUS_FOR_HEADER' , ' OPENING CURSOR' ,
    --          'INFO';
    
    /**/
    OPEN db_cursor2
    /**/
    
    WHILE @continue = 1 BEGIN
        FETCH NEXT FROM db_cursor2 INTO
            @DETAIL_ID,
            @INVOICE_DATE, @INVOICE_NUM
            , @OPEN_BALANCE, @QB_FEE, @MONTH, @YEAR;
        /**/
        IF @@FETCH_STATUS <> 0
            BEGIN
                SET @continue = 0
                BREAK
            END
        /**/
        
        SET @rowno = @rowno + 1;
        BEGIN TRY
            set @PRV_INV_SENT_AMOUNT = dbo.get_invoice_sent_total_paid( @INVOICE_NUM );
            
            if isnull( @OPEN_BALANCE , 0 ) > 0
                begin
                    set @NEW_LINE_STATUS = 'pending';
                end
            else
                begin
                    if isnull( @PRV_INV_SENT_AMOUNT , 0 ) = 0
                        begin
                            set @NEW_LINE_STATUS = 'paid';
                        end
                    else
                        begin
                            set @NEW_LINE_STATUS = concat( 'already paid: ' , @PRV_INV_SENT_AMOUNT );
                        end
                end
            
            /* update org employer name where null */
            UPDATE dbo.[STATEMENT_DETAILS]
            SET
                line_payment_status = @NEW_LINE_STATUS
            where
                DETAIL_ID = @DETAIL_ID;
            --
            --             SET @msg1 = CONCAT( '#RowNo ' , @rowno , 'Setting Status "' , @NEW_LINE_STATUS , '" FOR Client ' ,
            --                                 @client_name , ', Inv No: ' ,
            --                                 @INVOICE_NUM , ', OPEN_BALANCE: ' , @OPEN_BALANCE , ', PRV_INV_SENT_AMOUNT: ' ,
            --                                 @PRV_INV_SENT_AMOUNT )
            --
            --             EXEC db_log_message 'SP_CALC_STATEMENT_LINE_PAYMENT_STATUS_FOR_HEADER' , @msg1 , 'INFO';
            
            /**/
        END TRY BEGIN CATCH
            SET @msg1 = CONCAT( @rowno , ' - ' , 'ERROR: ' , ERROR_MESSAGE( ) , ' FOR RECORD ' , @msg1 );
            EXEC db_log_error 50001 , 'SP_CALC_STATEMENT_LINE_PAYMENT_STATUS_FOR_HEADER' , @msg1 ,
                 'ERROR';
        END CATCH
        
        /**/
    END
    /* while*/
    
    /**/
    CLOSE db_cursor2
    DEALLOCATE db_cursor2
    
    /* update total commissions per statement by examing statement details line_payment_status */
    /* not essential but it is nice to show users the totals for each broker for current months statements*/
    update dbo.STATEMENT_HEADER
    set
        STATEMENT_TOTAL                = dbo.get_broker_commission_paid_amount( BROKER_ID , MONTH , YEAR ),
        STATEMENT_PENDING_TOTAL= dbo.get_broker_commission_pending_amount( BROKER_ID , MONTH , YEAR ),
        STATEMENT_ALREADY_PAID_TOTAL= dbo.get_broker_commission_already_paid_amount( BROKER_ID , MONTH , YEAR ),
        STATEMENT_PROCESSED_THIS_PERIOD= dbo.get_total_processed_this_period( HEADER_ID );
    
    /* for comptablity with old code - use this column also*/
    update dbo.STATEMENT_HEADER
    set
        TOTAL = isnull( STATEMENT_TOTAL + STATEMENT_PENDING_TOTAL , 0 );
    
    /**/
    --
    --     SET @msg1 = CONCAT( '**LOG** ' , 'SP_CALC_STATEMENT_LINE_PAYMENT_STATUS_FOR_HEADER' ,
    --                         ' FINISHED ROW COUNT: ' , @rowno );
    --     RAISERROR (@msg1, 0, 1) WITH NOWAIT

END
go

