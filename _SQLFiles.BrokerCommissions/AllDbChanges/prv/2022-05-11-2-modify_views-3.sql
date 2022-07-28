use Broker_Commission;
go

create function get_invoice_sent_total_open_balance( @invNum nvarchar(500) ) returns numeric as
begin
    declare @amount numeric;
    
    select
        @amount = sum( [OPEN_BALANCE] )
    from
        [dbo].[SENT_INVOICE]
    where
        INVOICE_NUM_FORMATTED = rtrim( ltrim( upper( @invNum ) ) );
    
    return isnull( @amount , 0 );
end

create function get_broker_commission_amount( @broker_id int ) returns numeric as
begin
    declare @amount numeric;
    
    select
        @amount = sum( [COMMISSION AMOUNT] )
    from
        dbo.[COMMISSION_RESULT]
    where
        BROKER_ID = @broker_id;
    
    return isnull( @amount , 0 );
end

--  sumeet: modified to use indexed formatted columns
go
alter VIEW [dbo].[COMMISSION_SUMMARY]
    AS
        SELECT
            --DISTINCT
            RT.[BROKER_ID]
          , RT.[BROKER_NAME]
          , RT.PAYLOCITY_ID
          , dbo.get_broker_commission_amount( RT.BROKER_ID )
                TOTAL
        FROM
            [dbo].[COMMISSION_RESULT] AS RT
        GROUP BY
            RT.[BROKER_ID]
          , RT.[BROKER_NAME]
          , RT.PAYLOCITY_ID

go


alter VIEW [dbo].[COMMISSION_RESULT]
    AS
        WITH
            CTE_RESULT AS
                (
                    SELECT *
                    FROM
                        [dbo].[COMMISSION_RESULT_NAME0]
                    UNION ALL
                    SELECT *
                    FROM
                        [dbo].[COMMISSION_RESULT_NAME1]
                    UNION ALL
                    SELECT *
                    FROM
                        [dbo].[COMMISSION_RESULT_NAME2]
                    UNION ALL
                    SELECT *
                    FROM
                        [dbo].[COMMISSION_RESULT_NAME3]
                    UNION ALL
                    SELECT *
                    FROM
                        [dbo].[COMMISSION_RESULT_NAME4]
                    UNION ALL
                    SELECT *
                    FROM
                        [dbo].[COMMISSION_RESULT_NAME5]
                    UNION ALL
                    SELECT *
                    FROM
                        [dbo].[COMMISSION_RESULT_NAME6]
                    UNION ALL
                    SELECT *
                    FROM
                        [dbo].[VW_STATEMENT_DETAILS_ADD]
                
                )
            /*sumeet: note: modified to get all lines even if an invoice has been sent - instead we return total invoice sent amoumt  for downstream checks*/
        SELECT distinct
            A.*
          , dbo.get_invoice_sent_total_open_balance( A.Num ) as Total_Invoice_Sent_Open_Balance
        FROM
            CTE_RESULT AS A
                LEFT JOIN [dbo].[SENT_INVOICE] AS B ON RTRIM( LTRIM( A.[Num] ) ) = RTRIM( LTRIM( B.[INVOICE_NUM] ) )
    /*    WHERE
            B.[INVOICE_NUM] IS NULL*/
go

