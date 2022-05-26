use Broker_Commission;
go

exec sp_rename 'STATEMENT_HEADER.STATEMENT_PAID_THIS_PERIOD' , STATEMENT_PROCESSED_THIS_PERIOD , 'COLUMN'
go
exec sp_rename 'STATEMENT_HEADER_ARCHIVE.STATEMENT_PAID_THIS_PERIOD' , STATEMENT_PROCESSED_THIS_PERIOD , 'COLUMN'
go
delete
from
    STATEMENT_HEADER;
delete
from
    STATEMENT_DETAILS;
delete
from
    dbo.STATEMENT_HEADER_ARCHIVE;

alter table STATEMENT_HEADER
    add default 0 for STATEMENT_TOTAL
go

alter table STATEMENT_HEADER
    add default 0 for STATEMENT_PENDING_TOTAL
go

alter table STATEMENT_HEADER
    add default 0 for STATEMENT_ALREADY_PAID_TOTAL
go
alter table STATEMENT_HEADER
    add default 0 for STATEMENT_PROCESSED_THIS_PERIOD
go


alter table STATEMENT_HEADER
    alter column STATEMENT_TOTAL numeric(18, 2) not null
go

alter table STATEMENT_HEADER
    alter column STATEMENT_PENDING_TOTAL numeric(18, 2) not null
go

alter table STATEMENT_HEADER
    alter column STATEMENT_ALREADY_PAID_TOTAL numeric(18, 2) not null
go

alter table STATEMENT_HEADER
    alter column STATEMENT_PROCESSED_THIS_PERIOD numeric(18, 2) not null
go

alter table STATEMENT_header_archive
    add default 0 for STATEMENT_TOTAL
go

alter table STATEMENT_header_archive
    add default 0 for STATEMENT_PENDING_TOTAL
go

alter table STATEMENT_header_archive
    add default 0 for STATEMENT_ALREADY_PAID_TOTAL
go
alter table STATEMENT_header_archive
    add default 0 for STATEMENT_PROCESSED_THIS_PERIOD
go


alter table STATEMENT_header_archive
    alter column STATEMENT_TOTAL numeric(18, 2) not null
go

alter table STATEMENT_header_archive
    alter column STATEMENT_PENDING_TOTAL numeric(18, 2) not null
go

alter table STATEMENT_header_archive
    alter column STATEMENT_ALREADY_PAID_TOTAL numeric(18, 2) not null
go

alter table STATEMENT_header_archive
    alter column STATEMENT_PROCESSED_THIS_PERIOD numeric(18, 2) not null
go



create or
alter
    function get_invoice_sent_total_processed_this_period(
                                                         @invNum nvarchar(500),
                                                         @month varchar(50),
                                                         @year int ) returns numeric as
begin
    declare @amount numeric;
    --      total both [COMMISSION_PAID] + [OPEN_BALANCE] as that would be waht we sent out for the poeriod in question
    select
        @amount = sum( [COMMISSION_PAID] + [OPEN_BALANCE] )
    from
        [dbo].[SENT_INVOICE]
    where
          INVOICE_NUM_FORMATTED = rtrim( ltrim( upper( @invNum ) ) )
      and month = @month
      and year = @year;
    
    return isnull( @amount , 0 );
end
go


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
    DECLARE @YEAR int;
    DECLARE @MONTH varchar(50);
    
    SET @continue = 1
    
    DECLARE db_cursor2 CURSOR FOR
        SELECT
            DETAIL_ID
          , INVOICE_DATE
          , INVOICE_NUM
          , OPEN_BALANCE
          , QB_FEE
          , month
          , year
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
    
    --     EXEC db_log_message 'SP_CALC_STATEMENT_LINE_PAYMENT_STATUS_FOR_HEADER' , ' OPENING CURSOR' ,
    --          'INFO';
    
    /**/
    OPEN db_cursor2
    /**/
    
    WHILE @continue = 1 BEGIN
        FETCH NEXT FROM db_cursor2 INTO
            @DETAIL_ID,
            @INVOICE_DATE, @INVOICE_NUM
            , @OPEN_BALANCE, @QB_FEE, @MONTH, @YEAR;
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
            --
            --             SET @msg1 = CONCAT( '#RowNo ' , @rowno , 'Setting Status "' , @NEW_LINE_STATUS , '" FOR Client ' ,
            --                                 @client_name , ', Inv No: ' ,
            --                                 @INVOICE_NUM , ', OPEN_BALANCE: ' , @OPEN_BALANCE , ', PRV_INV_SENT_AMOUNT: ' ,
            --                                 @PRV_INV_SENT_AMOUNT )
            --
            --             EXEC db_log_message 'SP_CALC_STATEMENT_LINE_PAYMENT_STATUS_FOR_HEADER' , @msg1 , 'INFO';
            
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
        STATEMENT_TOTAL                = dbo.get_broker_commission_paid_amount( BROKER_ID , MONTH , YEAR ),
        STATEMENT_PENDING_TOTAL= dbo.get_broker_commission_pending_amount( BROKER_ID , MONTH , YEAR ),
        STATEMENT_ALREADY_PAID_TOTAL= dbo.get_broker_commission_already_paid_amount( BROKER_ID , MONTH , YEAR ),
        STATEMENT_PROCESSED_THIS_PERIOD= dbo.get_invoice_sent_total_processed_this_period( @INVOICE_NUM , MONTH ,
                                                                                           YEAR );
    
    /* for comptablity with old code - use this column also*/
    update dbo.STATEMENT_HEADER
    set
        TOTAL = isnull( STATEMENT_TOTAL + STATEMENT_PENDING_TOTAL , 0 );
    
    /**/
    --
    --     SET @msg1 = CONCAT( '**LOG** ' , 'SP_CALC_STATEMENT_LINE_PAYMENT_STATUS_FOR_HEADER' ,
    --                         ' FINISHED ROW COUNT: ' , @rowno );
    --     RAISERROR (@msg1, 0, 1) WITH NOWAIT

END
go

exec SP_IMPORT_FILE_SENT_SSIS 'JANUARY' , 2022;
