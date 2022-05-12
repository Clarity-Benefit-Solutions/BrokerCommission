use Broker_Commission;
Go;

alter table dbo.STATEMENT_HEADER add PAYLOCITY_ID int;
alter table dbo.STATEMENT_HEADER_ARCHIVE add PAYLOCITY_ID int;

alter table dbo.STATEMENT_HEADER add TOTAL numeric(18,2);
alter table dbo.STATEMENT_HEADER_ARCHIVE add TOTAL numeric(18,2);

create or
alter
    PROCEDURE [dbo].[SP_CALC_STATEMENT_LINE_PAYMENT_STATUS_FOR_HEADER]
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
                            set @NEW_LINE_STATUS = concat( 'already paid: ' , @PRV_INV_SENT_AMOUNT );
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
    
    /* update total commissions per statement by examing statement details line_payment_status */
    /* not essential but it is nice to show users the totals for each broker for current months statements*/
    update dbo.STATEMENT_HEADER
    set
        STATEMENT_TOTAL             = dbo.get_broker_commission_paid_amount( BROKER_ID , MONTH , YEAR ),
        STATEMENT_PENDING_TOTAL= dbo.get_broker_commission_pending_amount( BROKER_ID , MONTH , YEAR ),
        STATEMENT_ALREADY_PAID_TOTAL= dbo.get_broker_commission_already_paid_amount( BROKER_ID , MONTH , YEAR );
    
    /* for comptablity with old code - use this column also*/
    update dbo.STATEMENT_HEADER
    set
        TOTAL = STATEMENT_TOTAL + STATEMENT_PENDING_TOTAL;
    
    /**/
    
    SET @msg1 = CONCAT( '**LOG** ' , 'SP_CALC_STATEMENT_LINE_PAYMENT_STATUS_FOR_HEADER' ,
                        ' FINISHED ROW COUNT: ' , @rowno );
    RAISERROR (@msg1, 0, 1) WITH NOWAIT

END
go



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
                            set @NEW_LINE_STATUS = concat( 'already paid: ' , @PRV_INV_SENT_AMOUNT );
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
    
    /* update total commissions per statement by examing statement details line_payment_status */
    /* not essential but it is nice to show users the totals for each broker for current months statements*/
    update dbo.STATEMENT_HEADER
    set
        STATEMENT_TOTAL             = dbo.get_broker_commission_paid_amount( BROKER_ID , MONTH , YEAR ),
        STATEMENT_PENDING_TOTAL= dbo.get_broker_commission_pending_amount( BROKER_ID , MONTH , YEAR ),
        STATEMENT_ALREADY_PAID_TOTAL= dbo.get_broker_commission_already_paid_amount( BROKER_ID , MONTH , YEAR );
    
    /**/
    
    SET @msg1 = CONCAT( '**LOG** ' , 'SP_CALC_STATEMENT_LINE_PAYMENT_STATUS_FOR_HEADER' ,
                        ' FINISHED ROW COUNT: ' , @rowno );
    RAISERROR (@msg1, 0, 1) WITH NOWAIT

END
GO
/*

exec [dbo].[SP_CALC_STATEMENT_LINE_PAYMENT_STATUS] 'MARCH' , 2022;

select
    dbo.get_invoice_sent_total_paid( '032322EPENN' );
*/
