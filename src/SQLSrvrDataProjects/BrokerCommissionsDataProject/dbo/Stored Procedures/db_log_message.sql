create 
 PROCEDURE [dbo].[db_log_message](
                                      @msg_source nvarchar(200),
                                      @msg text,
                                      @log_level nvarchar(50),
                                      @recsaffected int = NULL,
                                      @print int = 1 ) AS
BEGIN
    BEGIN TRY
        DECLARE @recsaffected2 nvarchar(100) = IIF( ISNULL( @recsaffected , '' ) = '-1' , '' ,
                                                    CAST( @recsaffected AS nvarchar ) );
        DECLARE @msg1 nvarchar(max) = CONCAT( '**LOG** ' , 'RECSAFFECTED: ' , @recsaffected2 , ', FROM : ' ,
                                              @msg_source , ', MESSAGE : ' , @msg );
        IF @print > 0
            RAISERROR (@msg1, 0, 1) WITH NOWAIT
        /**/
        INSERT
            INTO db_message_log (
                                log_level,
                                log_source,
                                log_msg
        )
        VALUES (
               @log_level,
               @msg_source,
               CONCAT( @msg , ', RecsAffected : ' , @recsaffected2 )
               );
    END TRY BEGIN CATCH
        INSERT
            INTO dbo.db_error_log(
                                 sql_state,
                                 err_no,
                                 err_source,
                                 err_msg
        )
        VALUES (
               ERROR_SEVERITY( ),
               '' + ERROR_NUMBER( ),
               ERROR_PROCEDURE( ),
               CAST( ERROR_LINE( ) AS nvarchar ) + ' - ' + ERROR_MESSAGE( )
               );
    END CATCH
END;