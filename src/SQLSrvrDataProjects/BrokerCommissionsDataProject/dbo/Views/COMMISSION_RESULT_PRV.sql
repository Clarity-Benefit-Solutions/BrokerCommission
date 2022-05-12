CREATE VIEW [dbo].[COMMISSION_RESULT_PRV]
AS
    
    WITH
        CTE_RESULT AS
            (
                
                SELECT *
                FROM
                    [dbo].[COMMISSION_RESULT_NAME0_PRV]
                UNION
                SELECT *
                FROM
                    [COMMISSION_RESULT_NAME1_PRV]
                UNION
                SELECT *
                FROM
                    [COMMISSION_RESULT_NAME2_PRV]
                UNION
                SELECT *
                FROM
                    [COMMISSION_RESULT_NAME3_PRV]
                UNION
                SELECT *
                FROM
                    [COMMISSION_RESULT_NAME4_PRV]
                UNION
                SELECT *
                FROM
                    [COMMISSION_RESULT_NAME5_PRV]
                UNION
                SELECT *
                FROM
                    [COMMISSION_RESULT_NAME6_PRV]
                UNION
                (
                    SELECT
                        [RESULTID] ID
                      , BROKER_NAME BROKER_NAME
                      , BROKER_NAME QB_BROKER_NAME
                      , BROKER_NAME QB_AGENT
                      , QB_CLIENT_NAME CLIENT_NAME
                      , QB_CLIENT_NAME QB_CLIENT
                      , QB_FEE QB_FEE
                      , QB_FEE MEMO
                      , QUANTITY Qty
                      , SALES_PRICE [Sales Price]
                      , SALES_PRICE [Amount]
                      , 0 [Open Balance]
                      , COMMISSION_RATE COMMISSION_RATE
                      , UNIT UNIT
                      , TOTAL_PRICE [COMMISSION AMOUNT]
                      , BROKER_STATUS [BROKER_STATUS]
                      , '' EMAIL
                      , QB_CLIENT_NAME QB_CLIENT_NAME
                      , QB_FEE FEE_MEMO
                      , [BROKER_ID] BROKER_ID
                      , GETDATE( ) Date
                      , [PAYLOCITY_ID] PAYLOCITY_ID
                      , CONVERT( varchar(10) , [START_DATE] ) [START_DATE]
                      , CONVERT( varchar(10) , [DETAIL_ID] )
                      , GETDATE( )
                      , 0 [CLIENT_ID]
                    FROM
                        [dbo].[STATEMENT_DETAILS_ADD]
                )
            )
    
    SELECT DISTINCT
        A.*
    FROM
        CTE_RESULT AS A
            LEFT JOIN [dbo].[SENT_INVOICE] AS B ON RTRIM( LTRIM( A.[Num] ) ) = RTRIM( LTRIM( B.[INVOICE_NUM] ) )
    WHERE
        B.[INVOICE_NUM] IS NULL