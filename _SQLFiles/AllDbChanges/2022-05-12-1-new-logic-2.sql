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

create PROCEDURE [dbo].[SP_CALC_STATEMENT_LINE_PAYMENT_STATUS]
@month nvarchar(30),
@year int
AS
BEGIN
    select
        '';
end;
go
alter PROCEDURE [dbo].[SP_IMPORT_FILE_SENT_SSIS]
@month nvarchar(30),
@year int
AS
BEGIN
    
    if isnull( @month , '' ) = ''
        begin
            THROW 51000, 'Month Cannot be Empty', 1;
        end
    
    if isnull( @year , 0 ) = 0
        begin
            THROW 51000, 'Year Cannot be Empty', 1;
        end
    
    -- update current statement month and year
    update dbo.Import_OCT
    set
        statement_year  = @Year,
        statement_month = @Month;
    
    -- delete from import_archive
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
    
    -- delete curent statement header
    DELETE
    FROM
        [dbo].[STATEMENT_HEADER];
    
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
    
    -- delete curent statement details
    DELETE
    FROM
        [dbo].[STATEMENT_DETAILS];
    
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
    
    /* run sp that will update line payment status based on open_balance and sent_invoices*/
    exec SP_CALC_STATEMENT_LINE_PAYMENT_STATUS @month , @year;
    
    /* update total commissions per statement */
    update dbo.STATEMENT_HEADER
    set
        STATEMENT_TOTAL        = dbo.get_broker_commission_paid_amount( BROKER_ID , MONTH , YEAR ),
        STATEMENT_PENDING_TOTAL= dbo.get_broker_commission_pending_amount( BROKER_ID , MONTH , YEAR );
    
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


exec [dbo].[SP_IMPORT_FILE_SENT_SSIS] 'MARCH' , 2020

