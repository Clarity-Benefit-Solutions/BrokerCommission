create 
 PROCEDURE [dbo].[db_throw_error](
                                      @err_no nvarchar(50),
                                      @err_source nvarchar(200),
                                      @err_msg nvarchar(2000) ) AS
BEGIN
    DECLARE @err_src_msg nvarchar(2000);
    SET @err_src_msg = CONCAT( 'ERROR ' , @err_source , ' : ' , @err_msg );
    -- log error
    EXEC db_log_error @err_no , @err_source , @err_msg , '45000';
    THROW @err_no, @err_src_msg, 1;
END