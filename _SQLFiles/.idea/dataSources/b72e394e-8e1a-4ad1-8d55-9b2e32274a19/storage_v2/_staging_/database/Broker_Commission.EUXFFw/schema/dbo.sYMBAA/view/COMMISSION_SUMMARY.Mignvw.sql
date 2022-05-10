CREATE VIEW [dbo].[COMMISSION_SUMMARY]
AS
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
                            [dbo].[COMMISSION_RESULT] AS R

                        WHERE
                            --R.[Open Balance] = 0 AND
                            RT.BROKER_ID = R.BROKER_ID
                    ) TOTAL

                FROM
                    [dbo].[COMMISSION_RESULT] AS RT
                GROUP BY
                    RT.[BROKER_ID]
                  , RT.[BROKER_NAME]
                  , RT.PAYLOCITY_ID
            )

    SELECT *
    FROM
        CTE_ALLRESULT
--WHERE TOTAL != 0
go

