create 
 PROCEDURE [dbo].[db_log_error](
                                    @err_no varchar(50),
                                    @err_source varchar(200),
                                    @err_msg text,
                                    @sqlstate varchar(200) ) AS
BEGIN
    PRINT CONCAT( '****ERROR**** ' , ', SQLSTATE: ' , @sqlstate , ', ERRNO: ' , @err_no , ', FROM: ' , @err_source ,
                  ', MESSAGE: ' , @err_msg );
    /**/
    INSERT
        INTO db_error_log (
                          sql_state,
                          err_no,
                          err_source,
                          err_msg
    )
    VALUES (
           @sqlstate,
           @err_no,
           @err_source,
           @err_msg
           );
END;