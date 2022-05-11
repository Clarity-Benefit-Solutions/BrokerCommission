use Broker_Commission;
go

--  sumeet: modified to use indexed formatted columns
go
alter VIEW [dbo].[COMMISSION_RESULT_NAME0]
    AS
        SELECT
            OCT.ID
          , BC.BROKER_NAME
          , REPLACE( LTRIM( RTRIM( UPPER( BC.QB_BROKER_NAME ) ) ) , '&' , '' ) [QB_BROKER_NAME]
          , REPLACE( LTRIM( RTRIM( UPPER( OCT.Agent ) ) ) , '&' , '' ) [QB_AGENT]
          , REPLACE( LTRIM( RTRIM( UPPER( BC.CLIENT_NAME ) ) ) , '&' , '' ) [CLIENT_NAME]
          , REPLACE( LTRIM( RTRIM( UPPER( OCT.[Name] ) ) ) , '&' , '' ) [QB_CLIENT]
          , LTRIM( RTRIM( UPPER( BC.QB_FEE ) ) ) [QB_FEE]
          , LTRIM( RTRIM( UPPER( OCT.Memo ) ) ) [MEMO]
          , OCT.Qty
          , OCT.[Sales Price]
          , OCT.Amount
          , OCT.[Open Balance]
          , BC.COMMISSION_RATE
          , BC.UNIT
          , (CASE
                 WHEN BC.UNIT = 'Per Qt' THEN BC.COMMISSION_RATE * OCT.Qty
                 WHEN BC.UNIT = 'Per Amount' THEN BC.COMMISSION_RATE * OCT.Amount
                 WHEN BC.UNIT = 'Flat Rate' THEN BC.COMMISSION_RATE
             END) [COMMISSION AMOUNT]
          , BC.BROKER_STATUS
          , BC.EMAIL
          , BC.QB_CLIENT_NAME
          , BC.FEE_MEMO
          , BC.ID [BROKER_ID]
          , OCT.Date
          , BC.PAYLOCITY_ID
          , BC.[START_DATE]
          , OCT.[Num]
          , OCT.Date [INVOICE_DATE]
          , BC.[CLIENT_ID]
        FROM
            [dbo].[BROKER_CLIENT] AS BC
                LEFT JOIN [dbo].[Import_OCT] AS OCT
                          ON
                                  BC.QB_BROKER_NAME_FORMATTED = oct.Agent_FORMATTED
                                  and BC.QB_CLIENT_NAME_FORMATTED = oct.Name_FORMATTED
                                  AND bc.QB_FEE_FORMATTED = oct.memo_FORMATTED
        WHERE
              isnull( BC.QB_BROKER_NAME_FORMATTED , '' ) != ''
          AND OCT.ID IS NOT NULL

go

--  sumeet: modified to use indexed formatted columns
go
alter VIEW [dbo].[COMMISSION_RESULT_NAME1]
    AS
        SELECT
            
            OCT.ID
          , BC.BROKER_NAME
          , LTRIM( RTRIM( UPPER( BC.QB_BROKER_NAME ) ) ) [QB_BROKER_NAME]
          , LTRIM( RTRIM( UPPER( OCT.Agent ) ) ) [QB_AGENT]
          , REPLACE( LTRIM( RTRIM( UPPER( BC.CLIENT_NAME ) ) ) , '&' , '' ) [CLIENT_NAME]
          , REPLACE( LTRIM( RTRIM( UPPER( OCT.[Name] ) ) ) , '&' , '' ) [QB_CLIENT]
          , LTRIM( RTRIM( UPPER( BC.QB_FEE ) ) ) [QB_FEE]
          , LTRIM( RTRIM( UPPER( OCT.Memo ) ) ) [MEMO]
          , OCT.Qty
          , OCT.[Sales Price]
          , OCT.Amount
          , OCT.[Open Balance]
          , BC.COMMISSION_RATE
          , BC.UNIT
          , (CASE
                 WHEN BC.UNIT = 'Per Qt' THEN BC.COMMISSION_RATE * OCT.Qty
                 WHEN BC.UNIT = 'Per Amount' THEN BC.COMMISSION_RATE * OCT.Amount
                 WHEN BC.UNIT = 'Flat Rate' THEN BC.COMMISSION_RATE
             END) [COMMISSION AMOUNT]
          , BC.BROKER_STATUS
          , BC.EMAIL
          , BC.QB_CLIENT_NAME
          , BC.FEE_MEMO
          , BC.ID [BROKER_ID]
          , OCT.Date
          
          , BC.PAYLOCITY_ID
          , BC.[START_DATE]
          , OCT.[Num]
          , OCT.Date [INVOICE_DATE]
          , BC.[CLIENT_ID]
        FROM
            
            [dbo].[BROKER_CLIENT] AS BC
                LEFT JOIN [dbo].[Import_OCT] AS OCT
                          ON
                                  BC.BROKER_NAME_3_FORMATTED = oct.Agent_FORMATTED
                                  and BC.QB_CLIENT_NAME_FORMATTED = oct.Name_FORMATTED
                                  AND bc.QB_FEE_FORMATTED = oct.memo_FORMATTED
        WHERE
              isnull( BC.BROKER_NAME_3_FORMATTED , '' ) != ''
          AND OCT.ID IS NOT NULL;


go

--  sumeet: modified to use indexed formatted columns
go
alter VIEW [dbo].[COMMISSION_RESULT_NAME2]
    AS
        SELECT
            
            OCT.ID
          , BC.BROKER_NAME
          , LTRIM( RTRIM( UPPER( BC.QB_BROKER_NAME ) ) ) [QB_BROKER_NAME]
          , LTRIM( RTRIM( UPPER( OCT.Agent ) ) ) [QB_AGENT]
          , REPLACE( LTRIM( RTRIM( UPPER( BC.CLIENT_NAME ) ) ) , '&' , '' ) [CLIENT_NAME]
          , REPLACE( LTRIM( RTRIM( UPPER( OCT.[Name] ) ) ) , '&' , '' ) [QB_CLIENT]
          , LTRIM( RTRIM( UPPER( BC.QB_FEE ) ) ) [QB_FEE]
          , LTRIM( RTRIM( UPPER( OCT.Memo ) ) ) [MEMO]
          , OCT.Qty
          , OCT.[Sales Price]
          , OCT.Amount
          , OCT.[Open Balance]
          , BC.COMMISSION_RATE
          , BC.UNIT
          , (CASE
                 WHEN BC.UNIT = 'Per Qt' THEN BC.COMMISSION_RATE * OCT.Qty
                 WHEN BC.UNIT = 'Per Amount' THEN BC.COMMISSION_RATE * OCT.Amount
                 WHEN BC.UNIT = 'Flat Rate' THEN BC.COMMISSION_RATE
             END) [COMMISSION AMOUNT]
          , BC.BROKER_STATUS
          , BC.EMAIL
          , BC.QB_CLIENT_NAME
          , BC.FEE_MEMO
          , BC.ID [BROKER_ID]
          , OCT.Date
          
          , BC.PAYLOCITY_ID
          , BC.[START_DATE]
          , OCT.[Num]
          , OCT.Date [INVOICE_DATE]
          , BC.[CLIENT_ID]
        FROM
            [dbo].[BROKER_CLIENT] AS BC
                LEFT JOIN [dbo].[Import_OCT] AS OCT
                          ON
                                  BC.BROKER_NAME_1_FORMATTED = oct.Agent_FORMATTED
                                  and BC.QB_CLIENT_NAME_FORMATTED = oct.Name_FORMATTED
                                  AND bc.QB_FEE_FORMATTED = oct.memo_FORMATTED
        WHERE
              isnull( BC.BROKER_NAME_1_FORMATTED , '' ) != ''
          AND OCT.ID IS NOT NULL;

go

--  sumeet: modified to use indexed formatted columns
go
alter VIEW [dbo].[COMMISSION_RESULT_NAME3]
    AS
        SELECT
            
            OCT.ID
          , BC.BROKER_NAME
          , LTRIM( RTRIM( UPPER( BC.QB_BROKER_NAME ) ) ) [QB_BROKER_NAME]
          , LTRIM( RTRIM( UPPER( OCT.Agent ) ) ) [QB_AGENT]
          , REPLACE( LTRIM( RTRIM( UPPER( BC.CLIENT_NAME ) ) ) , '&' , '' ) [CLIENT_NAME]
          , REPLACE( LTRIM( RTRIM( UPPER( OCT.[Name] ) ) ) , '&' , '' ) [QB_CLIENT]
          , LTRIM( RTRIM( UPPER( BC.QB_FEE ) ) ) [QB_FEE]
          , LTRIM( RTRIM( UPPER( OCT.Memo ) ) ) [MEMO]
          , OCT.Qty
          , OCT.[Sales Price]
          , OCT.Amount
          , OCT.[Open Balance]
          , BC.COMMISSION_RATE
          , BC.UNIT
            --, ( CASE WHEN BC.UNIT ='Per Qt' THEN BC.COMMISSION_RATE * OCT.Qty WHEN BC.UNIT ='Per Amount'  THEN BC.COMMISSION_RATE * OCT.Amount END ) AS [COMMISSION AMOUNT]
          , (CASE
                 WHEN BC.UNIT = 'Per Qt' THEN BC.COMMISSION_RATE * OCT.Qty
                 WHEN BC.UNIT = 'Per Amount' THEN BC.COMMISSION_RATE * OCT.Amount
                 WHEN BC.UNIT = 'Flat Rate' THEN BC.COMMISSION_RATE
             END) [COMMISSION AMOUNT]
          , BC.BROKER_STATUS
          , BC.EMAIL
          , BC.QB_CLIENT_NAME
          , BC.FEE_MEMO
          , BC.ID [BROKER_ID]
          , OCT.Date
          , BC.PAYLOCITY_ID
          , BC.[START_DATE]
          , OCT.[Num]
          , OCT.Date [INVOICE_DATE]
          , BC.[CLIENT_ID]
        FROM
            [dbo].[BROKER_CLIENT] AS BC
                LEFT JOIN [dbo].[Import_OCT] AS OCT
                          ON
                                  BC.BROKER_NAME_2_FORMATTED = oct.Agent_FORMATTED
                                  and BC.QB_CLIENT_NAME_FORMATTED = oct.Name_FORMATTED
                                  AND bc.QB_FEE_FORMATTED = oct.memo_FORMATTED
        WHERE
              isnull( BC.BROKER_NAME_2_FORMATTED , '' ) != ''
          AND OCT.ID IS NOT NULL;

go

--  sumeet: modified to use indexed formatted columns
go
alter VIEW [dbo].[COMMISSION_RESULT_NAME4]
    AS
        SELECT
            
            OCT.ID
          , BC.BROKER_NAME
          , LTRIM( RTRIM( UPPER( BC.QB_BROKER_NAME ) ) ) [QB_BROKER_NAME]
          , LTRIM( RTRIM( UPPER( OCT.Agent ) ) ) [QB_AGENT]
          , REPLACE( LTRIM( RTRIM( UPPER( BC.CLIENT_NAME ) ) ) , '&' , '' ) [CLIENT_NAME]
          , REPLACE( LTRIM( RTRIM( UPPER( OCT.[Name] ) ) ) , '&' , '' ) [QB_CLIENT]
          , LTRIM( RTRIM( UPPER( BC.QB_FEE ) ) ) [QB_FEE]
          , LTRIM( RTRIM( UPPER( OCT.Memo ) ) ) [MEMO]
          , OCT.Qty
          , OCT.[Sales Price]
          , OCT.Amount
          , OCT.[Open Balance]
          , BC.COMMISSION_RATE
          , BC.UNIT
            --, ( CASE WHEN BC.UNIT ='Per Qt' THEN BC.COMMISSION_RATE * OCT.Qty WHEN BC.UNIT ='Per Amount'  THEN BC.COMMISSION_RATE * OCT.Amount END ) AS [COMMISSION AMOUNT]
          , (CASE
                 WHEN BC.UNIT = 'Per Qt' THEN BC.COMMISSION_RATE * OCT.Qty
                 WHEN BC.UNIT = 'Per Amount' THEN BC.COMMISSION_RATE * OCT.Amount
                 WHEN BC.UNIT = 'Flat Rate' THEN BC.COMMISSION_RATE
             END) [COMMISSION AMOUNT]
          , BC.BROKER_STATUS
          , BC.EMAIL
          , BC.QB_CLIENT_NAME
          , BC.FEE_MEMO
          , BC.ID [BROKER_ID]
          , OCT.Date
          , BC.PAYLOCITY_ID
          , BC.[START_DATE]
          , OCT.[Num]
          , OCT.Date [INVOICE_DATE]
          , BC.[CLIENT_ID]
        FROM
            [dbo].[BROKER_CLIENT] AS BC
                LEFT JOIN [dbo].[Import_OCT] AS OCT
                          ON
                                  BC.BROKER_NAME_4_FORMATTED = oct.Agent_FORMATTED
                                  and BC.QB_CLIENT_NAME_FORMATTED = oct.Name_FORMATTED
                                  AND bc.QB_FEE_FORMATTED = oct.memo_FORMATTED
        WHERE
              isnull( BC.BROKER_NAME_4_FORMATTED , '' ) != ''
          AND OCT.ID IS NOT NULL;

go

--  sumeet: modified to use indexed formatted columns
go
alter VIEW [dbo].[COMMISSION_RESULT_NAME5]
    AS
        SELECT
            
            OCT.ID
          , BC.BROKER_NAME
          , LTRIM( RTRIM( UPPER( BC.QB_BROKER_NAME ) ) ) [QB_BROKER_NAME]
          , LTRIM( RTRIM( UPPER( OCT.Agent ) ) ) [QB_AGENT]
          , REPLACE( LTRIM( RTRIM( UPPER( BC.CLIENT_NAME ) ) ) , '&' , '' ) [CLIENT_NAME]
          , REPLACE( LTRIM( RTRIM( UPPER( OCT.[Name] ) ) ) , '&' , '' ) [QB_CLIENT]
          , LTRIM( RTRIM( UPPER( BC.QB_FEE ) ) ) [QB_FEE]
          , LTRIM( RTRIM( UPPER( OCT.Memo ) ) ) [MEMO]
          , OCT.Qty
          , OCT.[Sales Price]
          , OCT.Amount
          , OCT.[Open Balance]
          , BC.COMMISSION_RATE
          , BC.UNIT
            --, ( CASE WHEN BC.UNIT ='Per Qt' THEN BC.COMMISSION_RATE * OCT.Qty WHEN BC.UNIT ='Per Amount'  THEN BC.COMMISSION_RATE * OCT.Amount END ) AS [COMMISSION AMOUNT]
          , (CASE
                 WHEN BC.UNIT = 'Per Qt' THEN BC.COMMISSION_RATE * OCT.Qty
                 WHEN BC.UNIT = 'Per Amount' THEN BC.COMMISSION_RATE * OCT.Amount
                 WHEN BC.UNIT = 'Flat Rate' THEN BC.COMMISSION_RATE
             END) [COMMISSION AMOUNT]
          , BC.BROKER_STATUS
          , BC.EMAIL
          , BC.QB_CLIENT_NAME
          , BC.FEE_MEMO
          , BC.ID [BROKER_ID]
          , OCT.Date
          
          , BC.PAYLOCITY_ID
          , BC.[START_DATE]
          , OCT.[Num]
          , OCT.Date [INVOICE_DATE]
          , BC.[CLIENT_ID]
        FROM
            [dbo].[BROKER_CLIENT] AS BC
                LEFT JOIN [dbo].[Import_OCT] AS OCT
                          ON
                                  BC.BROKER_NAME_5_FORMATTED = oct.Agent_FORMATTED
                                  and BC.QB_CLIENT_NAME_FORMATTED = oct.Name_FORMATTED
                                  AND bc.QB_FEE_FORMATTED = oct.memo_FORMATTED
        WHERE
              isnull( BC.BROKER_NAME_5_FORMATTED , '' ) != ''
          AND OCT.ID IS NOT NULL;

go

--  sumeet: modified to use indexed formatted columns
go
alter VIEW [dbo].[COMMISSION_RESULT_NAME6]
    AS
        SELECT
            
            OCT.ID
          , BC.BROKER_NAME
          , LTRIM( RTRIM( UPPER( BC.QB_BROKER_NAME ) ) ) [QB_BROKER_NAME]
          , LTRIM( RTRIM( UPPER( OCT.Agent ) ) ) [QB_AGENT]
          , REPLACE( LTRIM( RTRIM( UPPER( BC.CLIENT_NAME ) ) ) , '&' , '' ) [CLIENT_NAME]
          , REPLACE( LTRIM( RTRIM( UPPER( OCT.[Name] ) ) ) , '&' , '' ) [QB_CLIENT]
          , LTRIM( RTRIM( UPPER( BC.QB_FEE ) ) ) [QB_FEE]
          , LTRIM( RTRIM( UPPER( OCT.Memo ) ) ) [MEMO]
          , OCT.Qty
          , OCT.[Sales Price]
          , OCT.Amount
          , OCT.[Open Balance]
          , BC.COMMISSION_RATE
          , BC.UNIT
            --, ( CASE WHEN BC.UNIT ='Per Qt' THEN BC.COMMISSION_RATE * OCT.Qty WHEN BC.UNIT ='Per Amount'  THEN BC.COMMISSION_RATE * OCT.Amount END ) AS [COMMISSION AMOUNT]
          , (CASE
                 WHEN BC.UNIT = 'Per Qt' THEN BC.COMMISSION_RATE * OCT.Qty
                 WHEN BC.UNIT = 'Per Amount' THEN BC.COMMISSION_RATE * OCT.Amount
                 WHEN BC.UNIT = 'Flat Rate' THEN BC.COMMISSION_RATE
             END) [COMMISSION AMOUNT]
          , BC.BROKER_STATUS
          , BC.EMAIL
          , BC.QB_CLIENT_NAME
          , BC.FEE_MEMO
          , BC.ID [BROKER_ID]
          , OCT.Date
          
          , BC.PAYLOCITY_ID
          , BC.[START_DATE]
          , OCT.[Num]
          , OCT.Date [INVOICE_DATE]
          , BC.[CLIENT_ID]
        FROM
            [dbo].[BROKER_CLIENT] AS BC
                LEFT JOIN [dbo].[Import_OCT] AS OCT
                          ON
                                  BC.BROKER_NAME_6_FORMATTED = oct.Agent_FORMATTED
                                  and BC.QB_CLIENT_NAME_FORMATTED = oct.Name_FORMATTED
                                  AND bc.QB_FEE_FORMATTED = oct.memo_FORMATTED
        WHERE
              isnull( BC.BROKER_NAME_6_FORMATTED , '' ) != ''
          AND OCT.ID IS NOT NULL;

go
/* sumeet - view created for consistency in union query for COMMISSION_RESULT*/
go
alter view VW_STATEMENT_DETAILS_ADD
    as
        select
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
          , CONVERT( varchar(10) , [DETAIL_ID] ) Num
          , GETDATE( ) Invoice_Date
          , 0 [CLIENT_ID]
        FROM
            [dbo].[STATEMENT_DETAILS_ADD];

/* sumeet - union query modified to use VW_STATEMENT_DETAILS_ADD*/
go
alter VIEW [dbo].[COMMISSION_RESULT]
    AS
        WITH
            CTE_RESULT AS
                (
                    SELECT *
                    FROM
                        [dbo].[COMMISSION_RESULT_NAME0]
                    UNION
                    SELECT *
                    FROM
                        [dbo].[COMMISSION_RESULT_NAME1]
                    UNION
                    SELECT *
                    FROM
                        [dbo].[COMMISSION_RESULT_NAME2]
                    UNION
                    SELECT *
                    FROM
                        [dbo].[COMMISSION_RESULT_NAME3]
                    UNION
                    SELECT *
                    FROM
                        [dbo].[COMMISSION_RESULT_NAME4]
                    UNION
                    SELECT *
                    FROM
                        [dbo].[COMMISSION_RESULT_NAME5]
                    UNION
                    SELECT *
                    FROM
                        [dbo].[COMMISSION_RESULT_NAME6]
                    UNION
                    SELECT *
                    FROM
                        [dbo].[VW_STATEMENT_DETAILS_ADD]
                
                )
            /**/
        SELECT DISTINCT
            A.*
        FROM
            CTE_RESULT AS A
                LEFT JOIN [dbo].[SENT_INVOICE] AS B ON RTRIM( LTRIM( A.[Num] ) ) = RTRIM( LTRIM( B.[INVOICE_NUM] ) )
        WHERE
            B.[INVOICE_NUM] IS NULL

go

--  sumeet: open balance = 0 condition removed - is that correct? ToDo: Check this changed logic
go
alter VIEW [dbo].[COMMISSION_SUMMARY]
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
            /**/
        SELECT *
        FROM
            CTE_ALLRESULT
go



CREATE VIEW [dbo].[DASH_BOARD]
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


go

