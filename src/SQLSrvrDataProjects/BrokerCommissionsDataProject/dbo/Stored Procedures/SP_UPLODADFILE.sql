CREATE PROCEDURE [dbo].[SP_UPLODADFILE]
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