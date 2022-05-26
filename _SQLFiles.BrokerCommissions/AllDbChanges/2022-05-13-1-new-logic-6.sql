use Broker_Commission;
go

select *
from
    dbo.SENT_INVOICE;

alter table dbo.STATEMENT_HEADER
    add STATEMENT_PAID_THIS_PERIOD numeric(18, 2) null;

alter table dbo.STATEMENT_HEADER_ARCHIVE
    add STATEMENT_PAID_THIS_PERIOD numeric(18, 2) null;

alter table dbo.STATEMENT_DETAILS
    add TOTAL_PRICE_PAID_THIS_PERIOD numeric(18, 2) null;

alter table dbo.STATEMENT_DETAILS_ARCHIVE
    add TOTAL_PRICE_PAID_THIS_PERIOD numeric(18, 2) null;

alter table dbo.SENT_INVOICE
    add month varchar(50) not null;
alter table dbo.SENT_INVOICE
    add year int not null;
alter table dbo.SENT_INVOICE
    add BROKER_ID int not null;
alter table dbo.SENT_INVOICE
    add DATE_PAID datetime not null;
alter table SENT_INVOICE
    drop column DATE_ENTER
go



alter table SENT_INVOICE
    alter column INVOICE_NUM varchar(500) not null
go

alter table SENT_INVOICE
    alter column OPEN_BALANCE numeric(18, 2) not null
go

-- column does not support rename

-- don't know how to alter nullability of SENT_INVOICE.INVOICE_NUM_FORMATTED

exec sp_rename 'SENT_INVOICE.STATEMENT_TOTAL' , COMMISSION_PAID , 'COLUMN'
go

alter table SENT_INVOICE
    alter column COMMISSION_PAID numeric(18, 2) not null
go

create unique index INVOICE_NUM_FORMATTED
    on SENT_INVOICE (INVOICE_NUM_FORMATTED)
go



alter table dbo.[SENT_INVOICE]
    add INVOICE_NUM_FORMATTED
        as
            LTRIM(
                    RTRIM(
                            UPPER( INVOICE_NUM )
                        )
                ) PERSISTED;
Go

CREATE or
alter procedure dbo.SP_INSERT_SENT_INVOICE(
                                          @INVOICE_NUM varchar(500),
                                          @DATE_PAID datetime,
                                          @OPEN_BALANCE numeric(18, 2),
                                          @COMMISSION_PAID numeric(18, 2),
                                          @BROKER_ID int,
                                          @month varchar(50),
                                          @year int ) as
begin
    
    declare @id int;
    declare @msg varchar(max);
    
    SET NOCOUNT ON
    /* if fileLogId = 0 or processingTask = 'New', we will insert into main and detail tables
       else we will insert only into the detailed table
    */
    
    if isnull( @INVOICE_NUM , '' ) = ''
        begin
            THROW 51000, 'Invoice_Num Cannot be Empty', 1;
        end
    
    set @INVOICE_NUM = rtrim( ltrim( upper( @INVOICE_NUM ) ) );
    select top 1
        @id = id
    from
        dbo.SENT_INVOICE
    where
        INVOICE_NUM_FORMATTED = @INVOICE_NUM;
    
    if isnull( @id , 0 ) != 0
        begin
            set @msg = concat( 'Invoice_Num ' , @INVOICE_NUM , ' is already inserted in the table and marked as paid' );
            THROW 51000, @msg, 1;
        end
    
    insert into dbo.SENT_INVOICE(
                                INVOICE_NUM,
                                OPEN_BALANCE,
                                COMMISSION_PAID,
                                BROKER_ID,
                                month,
                                year,
                                DATE_PAID
    )
    values (
           @INVOICE_NUM,
           @OPEN_BALANCE,
           @COMMISSION_PAID,
           @BROKER_ID,
           @month,
           @year,
           @DATE_PAID
           );
    
    set @Id = SCOPE_IDENTITY( );
    /* return the header PK */
    select
        @id;
end;
go

exec SP_INSERT_SENT_INVOICE '1' , '2022-05-13' , 1 , 1 , 'JANUARY' , 2022;
go

create or
alter
    PROCEDURE [dbo].[SP_CALC_STATEMENT_LINE_PAYMENT_STATUS]
@month varchar(50),
@year int
AS
BEGIN
    
    DECLARE @msg1 nvarchar(max)
    DECLARE @rowno int = 0
    DECLARE @continue int = 0
    /**/
    
    DECLARE @header_id int;
    DECLARE @broker_id int;
    DECLARE @client_name varchar(1000);
    
    SET @continue = 1
    
    DECLARE db_cursor CURSOR FOR
        SELECT
            HEADER_ID
          , BROKER_ID
          , CLIENT_NAME
        FROM
            dbo.STATEMENT_DETAILS
        where
              month = @month
          and year = @year
        ORDER BY
            BROKER_ID;
    
    --     EXEC db_log_message 'SP_CALC_STATEMENT_LINE_PAYMENT_STATUS' , ' OPENING CURSOR' ,
    --          'INFO';
    --
    /* update all lines to null */
    UPDATE dbo.[STATEMENT_DETAILS]
    SET
        line_payment_status = null
    
    /**/
    OPEN db_cursor
    /**/
    
    WHILE @continue = 1 BEGIN
        FETCH NEXT FROM db_cursor INTO
            @header_id, @broker_id, @client_name;
        
        /**/
        IF @@FETCH_STATUS <> 0
            BEGIN
                SET @continue = 0
                BREAK
            END
        /**/
        
        SET @rowno = @rowno + 1;
        BEGIN TRY
            /*  SET @msg1 =
                      CONCAT( '#RowNo ' , @rowno , 'Processing Header id: ' , @header_id , ' Broker ID: ' , @broker_id ,
                              ' CLIENT: ' , @client_name )
              EXEC db_log_message 'SP_CALC_STATEMENT_LINE_PAYMENT_STATUS' , @msg1 , 'INFO';
             */
            exec SP_CALC_STATEMENT_LINE_PAYMENT_STATUS_FOR_HEADER @header_id , @broker_id , @client_name;
            
            /**/
        END TRY BEGIN CATCH
            SET @msg1 = CONCAT( @rowno , ' - ' , 'ERROR: ' , ERROR_MESSAGE( ) , ' FOR RECORD ' , @msg1 );
            EXEC db_log_error 50001 , 'SP_CALC_STATEMENT_LINE_PAYMENT_STATUS' , @msg1 ,
                 'ERROR';
        END CATCH
        
        /**/
    END
    /* while*/
    
    /**/
    CLOSE db_cursor
    DEALLOCATE db_cursor
    
    /**/
    SET @msg1 = CONCAT( '**LOG** ' , 'SP_CALC_STATEMENT_LINE_PAYMENT_STATUS' ,
                        ' FINISHED ROW COUNT: ' , @rowno );
    RAISERROR (@msg1, 0, 1) WITH NOWAIT

END
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
    
    SET @continue = 1
    
    DECLARE db_cursor2 CURSOR FOR
        SELECT
            DETAIL_ID
          , INVOICE_DATE
          , INVOICE_NUM
          , OPEN_BALANCE
          , QB_FEE
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
            , @OPEN_BALANCE, @QB_FEE;
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
        STATEMENT_TOTAL             = dbo.get_broker_commission_paid_amount( BROKER_ID , MONTH , YEAR ),
        STATEMENT_PENDING_TOTAL= dbo.get_broker_commission_pending_amount( BROKER_ID , MONTH , YEAR ),
        STATEMENT_ALREADY_PAID_TOTAL= dbo.get_broker_commission_already_paid_amount( BROKER_ID , MONTH , YEAR );
    
    /* for comptablity with old code - use this column also*/
    update dbo.STATEMENT_HEADER
    set
        TOTAL = STATEMENT_TOTAL + STATEMENT_PENDING_TOTAL;
    
    /**/
    --
    --     SET @msg1 = CONCAT( '**LOG** ' , 'SP_CALC_STATEMENT_LINE_PAYMENT_STATUS_FOR_HEADER' ,
    --                         ' FINISHED ROW COUNT: ' , @rowno );
    --     RAISERROR (@msg1, 0, 1) WITH NOWAIT

END
go


alter table SENT_INVOICE
    alter column OPEN_BALANCE numeric(18, 2) null

truncate table dbo.SENT_INVOICE

select *
from
    dbo.STATEMENT_HEADER

create
    PROCEDURE [dbo].[SP_IMPORT_FILE_SENT_SSIS]
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
    
    /*1. update current statement month and year in imported data for archival purposes*/
    update dbo.Import_OCT
    set
        statement_year  = @Year,
        statement_month = @Month;
    
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

END
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
    
    SET @continue = 1
    
    DECLARE db_cursor2 CURSOR FOR
        SELECT
            DETAIL_ID
          , INVOICE_DATE
          , INVOICE_NUM
          , OPEN_BALANCE
          , QB_FEE
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
            , @OPEN_BALANCE, @QB_FEE;
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
        STATEMENT_TOTAL             = dbo.get_broker_commission_paid_amount( BROKER_ID , MONTH , YEAR ),
        STATEMENT_PENDING_TOTAL= dbo.get_broker_commission_pending_amount( BROKER_ID , MONTH , YEAR ),
        STATEMENT_ALREADY_PAID_TOTAL= dbo.get_broker_commission_already_paid_amount( BROKER_ID , MONTH , YEAR ),
        STATEMENT_PAID_THIS_PERIOD= dbo.get_broker_commission_already_paid_amount( BROKER_ID , MONTH , YEAR );
    
    /* for comptablity with old code - use this column also*/
    update dbo.STATEMENT_HEADER
    set
        TOTAL = STATEMENT_TOTAL + STATEMENT_PENDING_TOTAL;
    
    /**/
    --
    --     SET @msg1 = CONCAT( '**LOG** ' , 'SP_CALC_STATEMENT_LINE_PAYMENT_STATUS_FOR_HEADER' ,
    --                         ' FINISHED ROW COUNT: ' , @rowno );
    --     RAISERROR (@msg1, 0, 1) WITH NOWAIT

END
go

