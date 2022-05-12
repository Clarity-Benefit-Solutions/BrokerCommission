CREATE VIEW [dbo].[COMMISSION_SUMMARY_PRV]
AS
    
    --SELECT * FROM  [dbo].[COMMISSION_RESULT] WHERE BROKER_ID = 1
    
    WITH
        CTE_ALLRESULT AS
            (
                SELECT
                    --DISTINCT
                    RT.[BROKER_ID]
                  , RT.[BROKER_NAME]
                  , RT.PAYLOCITY_ID
                  , (
                        SELECT
                            SUM( R.[COMMISSION AMOUNT] )
                        FROM
                            [dbo].[COMMISSION_RESULT_PRV] AS R
                      
                        WHERE
                            --R.[Open Balance] = 0 AND
                            RT.BROKER_ID = R.BROKER_ID
                    ) TOTAL
                
                FROM
                    [dbo].[COMMISSION_RESULT_PRV] AS RT
                GROUP BY
                    RT.[BROKER_ID]
                  , RT.[BROKER_NAME]
                  , RT.PAYLOCITY_ID
            )
        
        --SELECT * FROM [dbo].[COMMISSION_RESULT]
    
    SELECT *
    FROM
        CTE_ALLRESULT