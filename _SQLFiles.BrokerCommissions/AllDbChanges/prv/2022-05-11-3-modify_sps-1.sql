use Broker_Commission;
go

alter PROCEDURE [dbo].[SP_IMPORT_FILE_SENT_SSIS]
    
    -- Add the parameters for the stored procedure here

@Month nvarchar(30),
@Year int
AS

BEGIN
    
    -- SET NOCOUNT ON added to prevent extra result sets from
    
    -- interfering with SELECT statements.
    
    SET NOCOUNT ON;
    --EXEC msdb..sp_start_job @job_name='Broker_Commission'
    DELETE
    FROM
        [dbo].[STATEMENT_HEADER]
    WHERE
          [MONTH] = @Month
      AND [YEAR] = @Year
    
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
      , R.[BROKER_ID]
      , R.[BROKER_NAME]
      , 0
      , R.[TOTAL]
      , GETDATE( )
    FROM
        [dbo].[COMMISSION_SUMMARY] AS R
    WHERE
          R.[BROKER_NAME] IS NOT NULL
      AND R.BROKER_ID IS NOT NULL

END
go


alter PROCEDURE [dbo].[SP_STATEMENT_DETAIL_UPDATE]
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
    
    -- Insert statements for procedure here
    Declare @Id int
    
    While (
              SELECT
                  COUNT( * )
              FROM
                  [dbo].[STATEMENT_HEADER]
              WHERE
                  FLAG = 0
          ) > 0
        Begin
            Select Top 1
                @Id = HEADER_ID
            From
                [dbo].[STATEMENT_HEADER]
            Where
                FLAG = 0
            
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
            )
            SELECT
                @Id
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
            
            FROM
                [dbo].[STATEMENT_HEADER] AS HEADER
                    LEFT JOIN [dbo].[COMMISSION_RESULT] AS R ON HEADER.[BROKER_ID] = R.[BROKER_ID]
            
            WHERE
                  R.[QB_CLIENT_NAME] IS NOT NULL
              AND HEADER.HEADER_ID = @Id
            
            Update [dbo].[STATEMENT_HEADER]
            Set
                FLAG = 4
            Where
                HEADER_ID = @Id
        End
    
    TRUNCATE TABLE [dbo].[STATEMENT_DETAILS_ADD]
END
go

