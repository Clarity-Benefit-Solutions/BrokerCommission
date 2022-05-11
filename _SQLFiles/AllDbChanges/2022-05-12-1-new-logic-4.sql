use Broker_Commission;
Go;

create or
alter PROCEDURE [dbo].[SP_CALC_STATEMENT_LINE_PAYMENT_STATUS]
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
GO



create or
alter PROCEDURE [dbo].[SP_CALC_STATEMENT_LINE_PAYMENT_STATUS_FOR_HEADER]
@header_id int,
@broker_id int,
@client_name varchar(1000)
AS
BEGIN
    
    DECLARE @msg1 nvarchar(max)
    DECLARE @rowno int = 0
    DECLARE @continue int = 0
    /**/
    
    DECLARE @DETAIL_ID int;
    DECLARE @INVOICE_DATE datetime;
    DECLARE @INVOICE_NUM nvarchar(1000);
    DECLARE @OPEN_BALANCE numeric(18, 2);
    DECLARE @QB_FEE nvarchar(1000);
    DECLARE @NEW_LINE_STATUS nvarchar(100);
    DECLARE @PRV_INV_SENT_AMOUNT numeric(18, 2);
    
    SET @continue = 1
    
    DECLARE db_cursor2 CURSOR FOR
        SELECT
            DETAIL_ID
          , INVOICE_DATE
          , INVOICE_NUM
          , OPEN_BALANCE
          , QB_FEE
        FROM
            dbo.STATEMENT_DETAILS
        where
              HEADER_ID = @header_id
          and BROKER_ID = @broker_id
          and CLIENT_NAME = @client_name
        ORDER BY
            HEADER_ID
          , CLIENT_NAME
          , INVOICE_DATE
          , QB_FEE;
    
    EXEC db_log_message 'SP_CALC_STATEMENT_LINE_PAYMENT_STATUS_FOR_HEADER' , ' OPENING CURSOR' ,
         'INFO';
    
    /**/
    OPEN db_cursor2
    /**/
    
    WHILE @continue = 1 BEGIN
        FETCH NEXT FROM db_cursor2 INTO
            @DETAIL_ID,
            @INVOICE_DATE, @INVOICE_NUM
            , @OPEN_BALANCE, @QB_FEE;
        /**/
        IF @@FETCH_STATUS <> 0
            BEGIN
                SET @continue = 0
                BREAK
            END
        /**/
        
        SET @rowno = @rowno + 1;
        BEGIN TRY
            set @PRV_INV_SENT_AMOUNT = dbo.get_invoice_sent_total_paid( @INVOICE_NUM );
            
            if isnull( @OPEN_BALANCE , 0 ) > 0
                begin
                    set @NEW_LINE_STATUS = 'pending';
                end
            else
                begin
                    if isnull( @PRV_INV_SENT_AMOUNT , 0 ) = 0
                        begin
                            set @NEW_LINE_STATUS = 'paid';
                        end
                    else
                        begin
                            set @NEW_LINE_STATUS = concat( 'already paid' , @PRV_INV_SENT_AMOUNT );
                        end
                end
            
            /* update org employer name where null */
            UPDATE dbo.[STATEMENT_DETAILS]
            SET
                line_payment_status = @NEW_LINE_STATUS
            where
                DETAIL_ID = @DETAIL_ID;
            
            SET @msg1 = CONCAT( '#RowNo ' , @rowno , 'Setting Status "' , @NEW_LINE_STATUS , '" FOR Client ' ,
                                @client_name , ', Inv No: ' ,
                                @INVOICE_NUM , ', OPEN_BALANCE: ' , @OPEN_BALANCE , ', PRV_INV_SENT_AMOUNT: ' ,
                                @PRV_INV_SENT_AMOUNT )
            
            EXEC db_log_message 'SP_CALC_STATEMENT_LINE_PAYMENT_STATUS_FOR_HEADER' , @msg1 , 'INFO';
            
            /**/
        END TRY BEGIN CATCH
            SET @msg1 = CONCAT( @rowno , ' - ' , 'ERROR: ' , ERROR_MESSAGE( ) , ' FOR RECORD ' , @msg1 );
            EXEC db_log_error 50001 , 'SP_CALC_STATEMENT_LINE_PAYMENT_STATUS_FOR_HEADER' , @msg1 ,
                 'ERROR';
        END CATCH
        
        /**/
    END
    /* while*/
    
    /**/
    CLOSE db_cursor2
    DEALLOCATE db_cursor2
    
    /**/
    
    SET @msg1 = CONCAT( '**LOG** ' , 'SP_CALC_STATEMENT_LINE_PAYMENT_STATUS_FOR_HEADER' ,
                        ' FINISHED ROW COUNT: ' , @rowno );
    RAISERROR (@msg1, 0, 1) WITH NOWAIT

END
GO


exec [dbo].[SP_CALC_STATEMENT_LINE_PAYMENT_STATUS] 'MARCH' , 2022;

select
    dbo.get_invoice_sent_total_paid( '032322EPENN' );
