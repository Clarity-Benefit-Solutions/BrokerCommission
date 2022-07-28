use Broker_Commission;
go

alter PROCEDURE [dbo].[GET_TOTAL]( @bid AS int )
    -- Add the parameters for the stored procedure here

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
    
    -- Insert statements for procedure here
    SELECT
        TOTAL TOTAL_COMMISSION
    FROM
        [dbo].[COMMISSION_SUMMARY]
    WHERE
        BROKER_ID = @bid

END



go

-- Author:		<Author,,Name>

alter PROCEDURE [dbo].[SP_BU_PREVIOUSTABLE]
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
                                N'dbo.IMPORT_OCT_' + REPLACE( CONVERT( nvarchar(50) , GETDATE( ) , 101 ) , '/' , '' ) )
            )
            BEGIN
                --PRINT 'Stored procedure already exists';
                SET @SQL_t = 'DROP TABLE dbo.IMPORT_OCT_' +
                             REPLACE( CONVERT( nvarchar(50) , GETDATE( ) , 101 ) , '/' , '' )
                EXEC (@SQL_t);
            END
    
    END
    BEGIN
        
        SET @SQL = 'SELECT *
	INTO dbo.IMPORT_OCT_' + REPLACE( CONVERT( nvarchar(50) , GETDATE( ) , 101 ) , '/' , '' ) + '
	from [dbo].[Import_OCT]'
        EXEC (@SQL);
    END
END

go

-- Author:		<Author,,Name>

alter PROCEDURE [dbo].[SP_FILE_IMPORT_SSIS]
    -- Add the parameters for the stored procedure here

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
    
    EXEC [dbo].[SP_UPLODADFILE]
END



go



-- Author: <Author,,Name>

-- Description: <Description,,>

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
        [dbo].Statement_Header
    WHERE
          [MONTH] = @Month
      AND [YEAR] = @Year
    
    INSERT INTO [dbo].Statement_Header
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



-- Author:		<Zhu,,Alfred>
-- Create date: <01/27/2022>

alter PROCEDURE [dbo].[SP_STATEMENT_DETAIL_UPDATE]
    -- Add the parameters for the stored procedure here
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
                  [dbo].Statement_Header
              WHERE
                  FLAG = 0
          ) > 0
        Begin
            Select Top 1
                @Id = HEADER_ID
            From
                [dbo].Statement_Header
            Where
                FLAG = 0
            
            INSERT INTO [dbo].Statement_Details
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
                [dbo].Statement_Header AS HEADER
                    LEFT JOIN [dbo].[COMMISSION_RESULT] AS R ON HEADER.[BROKER_ID] = R.[BROKER_ID]
            
            WHERE
                  R.[QB_CLIENT_NAME] IS NOT NULL
              AND HEADER.HEADER_ID = @Id
            
            Update [dbo].Statement_Header
            Set
                FLAG = 4
            Where
                HEADER_ID = @Id
        End
    
    TRUNCATE TABLE [dbo].Statement_Details_Add
END
go

-- Author:		<Author,,Name>

alter PROCEDURE [dbo].[SP_UPLODADFILE]
    -- Add the parameters for the stored procedure here

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
    
    -- Insert statements for procedure here
    
    DECLARE @JobId binary(16)
    SELECT
        @JobId = job_id
    FROM
        msdb.dbo.sysjobs
    WHERE
        (name = 'Broker_Commission')
    
    IF (@JobId IS NOT NULL)
        BEGIN
            EXEC msdb.dbo.sp_start_job @job_id = @JobId;
        END
    --declare @execution_id bigint
    --exec ssisdb.catalog.create_execution
    -- @folder_name = 'Broker_Commission'
    --,@project_name = 'BrokerCommission_SSIS'
    --,@package_name = 'Package.dtsx'
    --,@execution_id = @execution_id output
    --exec ssisdb.catalog.start_execution @execution_id
    --set @output_execution_id = @execution_id

END
go

