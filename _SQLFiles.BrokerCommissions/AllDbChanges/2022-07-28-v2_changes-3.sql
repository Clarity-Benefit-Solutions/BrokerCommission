use Broker_Commission;
go
CREATE or alter VIEW [dbo].[COMMISSION_RESULT_NAME_NEW]
AS
    SELECT
        OCT.ID
      , BC.BROKER_NAME
      , REPLACE( LTRIM( RTRIM( UPPER( BC.QB_BROKER_NAME ) ) ) , '&' , '' ) [QB_BROKER_NAME]
      , REPLACE( LTRIM( RTRIM( UPPER( OCT.Agent ) ) ) , '&' , '' ) [QB_AGENT]
      , REPLACE( LTRIM( RTRIM( UPPER( BC.CLIENT_NAME ) ) ) , '&' , '' ) [CLIENT_NAME]
      , REPLACE( LTRIM( RTRIM( UPPER( OCT.[Name] ) ) ) , '&' , '' ) [QB_CLIENT]
      , LTRIM( RTRIM( UPPER( BC.QB_FEE ) ) ) [QB_FEE]
      , LTRIM( RTRIM( UPPER( OCT.Memo ) ) ) [MEMO]
      , cast( OCT.Qty as numeric(18, 2) ) Qty
      , OCT.[Sales Price]
      , OCT.Amount
      , OCT.[Open Balance]
      , BC.COMMISSION_RATE
      , BC.UNIT
      , (CASE
             WHEN BC.UNIT = 'Per Qt' THEN BC.COMMISSION_RATE * OCT.Qty
             WHEN BC.UNIT = 'Per Amount' THEN BC.COMMISSION_RATE * OCT.Amount
             WHEN BC.UNIT = 'Flat Rate' THEN BC.COMMISSION_RATE
         END) [COMMISSION AMOUNT]
      , BC.BROKER_STATUS
      , BC.EMAIL
      , BC.QB_CLIENT_NAME
      , BC.MEMO as FEE_MEMO
      , BC.ID [BROKER_ID]
      , OCT.Date
      , BC.PAYLOCITY_ID
      , BC.[START_DATE]
      , OCT.[Num]
      , OCT.Date [INVOICE_DATE]
      , BC.[CLIENT_ID]
    FROM
        [dbo].[BROKER_CLIENT] AS BC
            LEFT JOIN [dbo].[Import] AS OCT
                      ON
                              /*BC.QB_BROKER_NAME_FORMATTED = oct.Agent_FORMATTED
                              and*/
                              BC.QB_CLIENT_NAME_FORMATTED = oct.Name_FORMATTED
                              AND bc.QB_FEE_FORMATTED = oct.memo_FORMATTED
    WHERE
        /*  isnull( BC.QB_BROKER_NAME_FORMATTED , '' ) != ''
      AND*/
        OCT.ID IS NOT NULL
go

CREATE or alter VIEW [dbo].[COMMISSION_RESULT]
AS
    WITH
        CTE_RESULT AS
            (
                /*  SELECT *
                  FROM
                      [dbo].[COMMISSION_RESULT_NAME0]
                  UNION ALL
                  SELECT *
                  FROM
                      [dbo].[COMMISSION_RESULT_NAME1]
                  UNION ALL
                  SELECT *
                  FROM
                      [dbo].[COMMISSION_RESULT_NAME2]
                  UNION ALL
                  SELECT *
                  FROM
                      [dbo].[COMMISSION_RESULT_NAME3]
                  UNION ALL
                  SELECT *
                  FROM
                      [dbo].[COMMISSION_RESULT_NAME4]
                  UNION ALL
                  SELECT *
                  FROM
                      [dbo].[COMMISSION_RESULT_NAME5]
                  UNION ALL
                  SELECT *
                  FROM
                      [dbo].[COMMISSION_RESULT_NAME6]*/
                SELECT *
                FROM
                    [COMMISSION_RESULT_NAME_NEW]
                UNION ALL
                SELECT *
                FROM
                    [dbo].[VW_STATEMENT_DETAILS_ADD]
            
            )
        /*sumeet: note: modified to get all lines even if an invoice has been sent - instead we return total invoice sent amoumt  for downstream checks*/
    SELECT distinct
        A.*
      , dbo.get_invoice_sent_total_open_balance( A.Num ) Total_Invoice_Sent_Open_Balance
    FROM
        CTE_RESULT AS A
            LEFT JOIN [dbo].[SENT_INVOICE] AS B ON RTRIM( LTRIM( A.[Num] ) ) = RTRIM( LTRIM( B.[INVOICE_NUM] ) )
go

CREATE or alter PROCEDURE [dbo].[SP_BU_PREVIOUSTABLE]
    -- Add the parameters for the stored procedure here

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
    
    -- Insert statements for procedure here
    DECLARE @SQL_h nvarchar(2000);
    DECLARE @Num nvarchar(2000);
    DECLARE @SQL nvarchar(2000);
    DECLARE @SQL_t nvarchar(2000);
    BEGIN
        
        IF EXISTS
            (
                SELECT *
                FROM
                    sys.objects
                WHERE
                        object_id = OBJECT_ID(
                                N'dbo.Import_' + REPLACE( CONVERT( nvarchar(50) , GETDATE( ) , 101 ) , '/' , '' ) )
            )
            BEGIN
                --PRINT 'Stored procedure already exists';
                SET @SQL_t = 'DROP TABLE dbo.Import_' +
                             REPLACE( CONVERT( nvarchar(50) , GETDATE( ) , 101 ) , '/' , '' )
                EXEC (@SQL_t);
            END
    
    END
    BEGIN
        
        SET @SQL = 'SELECT *
	INTO dbo.Import_' + REPLACE( CONVERT( nvarchar(50) , GETDATE( ) , 101 ) , '/' , '' ) + '
	from [dbo].[Import]'
        EXEC (@SQL);
    END
END
go

create or alter
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
    
    set @month = dbo.format_field( @month );
    
    /*1. update current statement month and year in imported data for archival purposes*/
    update dbo.Import
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
        dbo.Import
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

create or alter

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
    
    set @month = dbo.format_field( @month );
    
    /*1. update current statement month and year in imported data for archival purposes*/
    update dbo.Import
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
        dbo.Import
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
    exec SP_UPDATE_STATEMENT_PAYMENT_STATUS @month , @year;

END
go

create or alter
 procedure SP_UPDATE_STATEMENT_PAYMENT_STATUS
@month nvarchar(30),
@year int
as
begin
    
    /* this does not truncate statements and reimport from Import - it just recalculates totals after emailing statements by checking against snet_invoices*/
    
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
    
--      update header totals
    exec sp_update_header_totals;
end
go


