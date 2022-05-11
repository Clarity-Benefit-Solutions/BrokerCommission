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

