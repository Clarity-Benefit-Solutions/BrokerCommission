create 
 PROCEDURE [dbo].[SP_CALC_STATEMENT_LINE_PAYMENT_STATUS]
@month varchar(50),
@year int
AS
BEGIN
    
    DECLARE @msg1 nvarchar(max)
    DECLARE @rowno int = 0
    DECLARE @continue int = 0
    /**/
    
    DECLARE @header_id int;
    DECLARE @broker_id int;
    DECLARE @client_name varchar(1000);
    
    SET @continue = 1
    
    DECLARE db_cursor CURSOR FOR
        SELECT
            HEADER_ID
          , BROKER_ID
          , CLIENT_NAME
        FROM
            dbo.STATEMENT_DETAILS
        where
              month = @month
          and year = @year
        ORDER BY
            BROKER_ID;
    
    EXEC db_log_message 'SP_CALC_STATEMENT_LINE_PAYMENT_STATUS' , ' OPENING CURSOR' ,
         'INFO';
    
    /* update all lines to null */
    UPDATE dbo.[STATEMENT_DETAILS]
    SET
        line_payment_status = null
    
    /**/
    OPEN db_cursor
    /**/
    
    WHILE @continue = 1 BEGIN
        FETCH NEXT FROM db_cursor INTO
            @header_id, @broker_id, @client_name;
        
        /**/
        IF @@FETCH_STATUS <> 0
            BEGIN
                SET @continue = 0
                BREAK
            END
        /**/
        
        SET @rowno = @rowno + 1;
        BEGIN TRY
            /*  SET @msg1 =
                      CONCAT( '#RowNo ' , @rowno , 'Processing Header id: ' , @header_id , ' Broker ID: ' , @broker_id ,
                              ' CLIENT: ' , @client_name )
              EXEC db_log_message 'SP_CALC_STATEMENT_LINE_PAYMENT_STATUS' , @msg1 , 'INFO';
             */
            exec SP_CALC_STATEMENT_LINE_PAYMENT_STATUS_FOR_HEADER @header_id , @broker_id , @client_name;
            
            /**/
        END TRY BEGIN CATCH
            SET @msg1 = CONCAT( @rowno , ' - ' , 'ERROR: ' , ERROR_MESSAGE( ) , ' FOR RECORD ' , @msg1 );
            EXEC db_log_error 50001 , 'SP_CALC_STATEMENT_LINE_PAYMENT_STATUS' , @msg1 ,
                 'ERROR';
        END CATCH
        
        /**/
    END
    /* while*/
    
    /**/
    CLOSE db_cursor
    DEALLOCATE db_cursor
    
    /**/
    
    SET @msg1 = CONCAT( '**LOG** ' , 'SP_CALC_STATEMENT_LINE_PAYMENT_STATUS' ,
                        ' FINISHED ROW COUNT: ' , @rowno );
    RAISERROR (@msg1, 0, 1) WITH NOWAIT

END