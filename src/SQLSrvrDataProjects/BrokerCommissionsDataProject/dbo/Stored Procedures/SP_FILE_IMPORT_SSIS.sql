CREATE PROCEDURE [dbo].[SP_FILE_IMPORT_SSIS]
    -- Add the parameters for the stored procedure here

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
    
    EXEC [dbo].[SP_UPLODADFILE]
END