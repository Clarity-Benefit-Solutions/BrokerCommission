CREATE PROCEDURE [dbo].[SP_BU_PREVIOUSTABLE]
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