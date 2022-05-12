CREATE VIEW [dbo].[DASH_BOARD_prv]
AS
    (
    
    SELECT
        BM.*
      , (
            SELECT
                SUM( [STATEMENT_TOTAL] )
            FROM
                [dbo].[STATEMENT_HEADER] AS BC
            WHERE
                  BC.BROKER_ID = BM.ID
              AND FLAG = 3
        ) TOTAL_AMOUNT
    
    FROM
        [dbo].[BROKER_MASTER] AS BM
        --LEFT JOIN dbo.STATEMENT_HEADER AS HD ON BM.ID = HD.BROKER_ID
        )