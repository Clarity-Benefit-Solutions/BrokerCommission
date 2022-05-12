use Broker_Commission;
Go;

alter VIEW [dbo].[COMMISSION_SUMMARY]
    AS
        SELECT DISTINCT
            RT.[BROKER_ID]
          , RT.[BROKER_NAME]
          , RT.PAYLOCITY_ID
        FROM
            [dbo].[COMMISSION_RESULT] AS RT
        GROUP BY
            RT.[BROKER_ID]
          , RT.[BROKER_NAME]
          , RT.PAYLOCITY_ID
go

create or
alter PROCEDURE [dbo].[SP_CALC_STATEMENT_LINE_PAYMENT_STATUS]
@month nvarchar(30),
@year int
AS
BEGIN
    select
        '';
end;
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
    [STATEMENT_TOTAL],
    [Change_Date]
    )
    SELECT
        @Month
      , @Year
      , RT.[BROKER_ID]
      , RT.[BROKER_NAME]
      , 0
      , 0
      , getdate( )
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
/*

exec [dbo].[SP_IMPORT_FILE_SENT_SSIS] 'MARCH' , 2020

*/
