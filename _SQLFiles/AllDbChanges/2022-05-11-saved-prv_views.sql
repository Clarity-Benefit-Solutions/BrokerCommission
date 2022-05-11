use Broker_Commission
go

CREATE VIEW [dbo].[BROKER_CLIENT_PRV]
AS
    (
    SELECT
        
        BM.ID
      , BM.BROKER_NAME
      , REPLACE( BM.BROKER_NAME_ID , '&' , '' ) QB_BROKER_NAME
      , CL.CLIENT_NAME
      , CL.QB_FEE
      
      , BM.BROKER_STATUS
      , BM.EMAIL
      
      , CL.QB_CLIENT_NAME
      
      , CL.FEE_MEMO
      , CL.COMMISSION_RATE
      , CL.UNIT
      , BM.PAYLOCITY_ID
      , BM.SECONDARY_EMAIL
      , BM.BROKER_NAME_1
      , BM.BROKER_NAME_2
      , BM.BROKER_NAME_3
      , BM.BROKER_NAME_4
      , BM.BROKER_NAME_5
      , BM.BROKER_NAME_6
      , CL.[START_DATE]
      , CL.CLIENT_ID
    
    FROM
        [dbo].[BROKER_MASTER] AS BM
            LEFT JOIN [dbo].[CLIENT] AS CL ON BM.ID = CL.BROKER_ID
    
    WHERE
        CL.BROKER_ID IS NOT NULL
        
        --ORDER BY BM.ID
        )


go



CREATE VIEW [dbo].[COMMISSION_RESULT_NAME0_PRV]
AS
    (
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
        [dbo].[BROKER_CLIENT_PRV] AS BC
            LEFT JOIN [dbo].[Import_OCT] AS OCT
                      ON
                          --LTRIM(RTRIM(UPPER(REPLACE(BC.QB_BROKER_NAME,'&','')))) =  LTRIM(RTRIM(UPPER(REPLACE(OCT.Agent, '&',''))))
                                  REPLACE( REPLACE( REPLACE( REPLACE( REPLACE(
                                                                              REPLACE( LTRIM( RTRIM( UPPER( BC.QB_BROKER_NAME ) ) ) , '&' , '' ) ,
                                                                              ',' , '' ) , '.' , '' ) , ' - ' , '-' ) ,
                                                    '- ' , '-' ) , '-' , '' ) = REPLACE( REPLACE( REPLACE( REPLACE(
                                                                                                                   REPLACE(
                                                                                                                           REPLACE( LTRIM( RTRIM( UPPER( OCT.Agent ) ) ) , '&' , '' ) ,
                                                                                                                           ',' ,
                                                                                                                           '' ) ,
                                                                                                                   '.' ,
                                                                                                                   '' ) ,
                                                                                                           ' - ' ,
                                                                                                           '-' ) ,
                                                                                                  '- ' , '-' ) , '-' ,
                                                                                         '' )
                              AND REPLACE( REPLACE( REPLACE( REPLACE( REPLACE(
                                                                              REPLACE( LTRIM( RTRIM( UPPER( BC.QB_CLIENT_NAME ) ) ) , '&' , '' ) ,
                                                                              ',' , '' ) , '.' , '' ) , ' - ' , '-' ) ,
                                                    '- ' , '-' ) , '-' , '' ) = REPLACE( REPLACE( REPLACE( REPLACE(
                                                                                                                   REPLACE(
                                                                                                                           REPLACE( LTRIM( RTRIM( UPPER( OCT.[Name] ) ) ) , '&' , '' ) ,
                                                                                                                           ',' ,
                                                                                                                           '' ) ,
                                                                                                                   '.' ,
                                                                                                                   '' ) ,
                                                                                                           ' - ' ,
                                                                                                           '-' ) ,
                                                                                                  '- ' , '-' ) , '-' ,
                                                                                         '' )
                              AND LTRIM( RTRIM( UPPER( BC.QB_FEE ) ) ) = LTRIM( RTRIM( UPPER( OCT.Memo ) ) )
    WHERE
          LTRIM( RTRIM( UPPER( BC.QB_BROKER_NAME ) ) ) != ''
      AND OCT.ID IS NOT NULL
        
        )

go



CREATE VIEW [dbo].[COMMISSION_RESULT_NAME1_PRV]
AS
    (
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
        [dbo].[BROKER_CLIENT_PRV] AS BC
            LEFT JOIN [dbo].[Import_OCT] AS OCT
                      ON
                          --LTRIM(RTRIM(UPPER(BC.BROKER_NAME_3))) =  LTRIM(RTRIM(UPPER(OCT.Agent)))
                                  REPLACE( REPLACE( REPLACE( REPLACE( REPLACE(
                                                                              REPLACE( LTRIM( RTRIM( UPPER( BC.BROKER_NAME_3 ) ) ) , '&' , '' ) ,
                                                                              ',' , '' ) , '.' , '' ) , ' - ' , '-' ) ,
                                                    '- ' , '-' ) , '-' , '' ) = REPLACE( REPLACE( REPLACE( REPLACE(
                                                                                                                   REPLACE(
                                                                                                                           REPLACE( LTRIM( RTRIM( UPPER( OCT.Agent ) ) ) , '&' , '' ) ,
                                                                                                                           ',' ,
                                                                                                                           '' ) ,
                                                                                                                   '.' ,
                                                                                                                   '' ) ,
                                                                                                           ' - ' ,
                                                                                                           '-' ) ,
                                                                                                  '- ' , '-' ) , '-' ,
                                                                                         '' )
                              AND REPLACE( REPLACE( REPLACE( REPLACE( REPLACE(
                                                                              REPLACE( LTRIM( RTRIM( UPPER( BC.QB_CLIENT_NAME ) ) ) , '&' , '' ) ,
                                                                              ',' , '' ) , '.' , '' ) , ' - ' , '-' ) ,
                                                    '- ' , '-' ) , '-' , '' ) = REPLACE( REPLACE( REPLACE( REPLACE(
                                                                                                                   REPLACE(
                                                                                                                           REPLACE( LTRIM( RTRIM( UPPER( OCT.[Name] ) ) ) , '&' , '' ) ,
                                                                                                                           ',' ,
                                                                                                                           '' ) ,
                                                                                                                   '.' ,
                                                                                                                   '' ) ,
                                                                                                           ' - ' ,
                                                                                                           '-' ) ,
                                                                                                  '- ' , '-' ) , '-' ,
                                                                                         '' )
                              AND LTRIM( RTRIM( UPPER( BC.QB_FEE ) ) ) = LTRIM( RTRIM( UPPER( OCT.Memo ) ) )
    WHERE
          LTRIM( RTRIM( UPPER( BC.BROKER_NAME_3 ) ) ) != ''
      AND BC.BROKER_NAME_3 IS NOT NULL
      AND OCT.ID IS NOT NULL
        )



go



CREATE VIEW [dbo].[COMMISSION_RESULT_NAME2_PRV]
AS
    (
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
        [dbo].[BROKER_CLIENT_PRV] AS BC
            LEFT JOIN [dbo].[Import_OCT] AS OCT
                      ON
                                  REPLACE( REPLACE( REPLACE( REPLACE( REPLACE(
                                                                              REPLACE( LTRIM( RTRIM( UPPER( BC.BROKER_NAME_1 ) ) ) , '&' , '' ) ,
                                                                              ',' , '' ) , '.' , '' ) , ' - ' , '-' ) ,
                                                    '- ' , '-' ) , '-' , '' ) = REPLACE( REPLACE( REPLACE( REPLACE(
                                                                                                                   REPLACE(
                                                                                                                           REPLACE( LTRIM( RTRIM( UPPER( OCT.Agent ) ) ) , '&' , '' ) ,
                                                                                                                           ',' ,
                                                                                                                           '' ) ,
                                                                                                                   '.' ,
                                                                                                                   '' ) ,
                                                                                                           ' - ' ,
                                                                                                           '-' ) ,
                                                                                                  '- ' , '-' ) , '-' ,
                                                                                         '' )
                              AND REPLACE( REPLACE( REPLACE( REPLACE( REPLACE(
                                                                              REPLACE( LTRIM( RTRIM( UPPER( BC.QB_CLIENT_NAME ) ) ) , '&' , '' ) ,
                                                                              ',' , '' ) , '.' , '' ) , ' - ' , '-' ) ,
                                                    '- ' , '-' ) , '-' , '' ) = REPLACE( REPLACE( REPLACE( REPLACE(
                                                                                                                   REPLACE(
                                                                                                                           REPLACE( LTRIM( RTRIM( UPPER( OCT.[Name] ) ) ) , '&' , '' ) ,
                                                                                                                           ',' ,
                                                                                                                           '' ) ,
                                                                                                                   '.' ,
                                                                                                                   '' ) ,
                                                                                                           ' - ' ,
                                                                                                           '-' ) ,
                                                                                                  '- ' , '-' ) , '-' ,
                                                                                         '' )
                              --LTRIM(RTRIM(UPPER(BC.BROKER_NAME_1))) =  LTRIM(RTRIM(UPPER(OCT.Agent)))
                              --AND  REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(UPPER(BC.QB_CLIENT_NAME))),'&',''),',',''),'.',''),' - ','-'),'- ','-'),'-','') =  REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(UPPER(OCT.[Name]))),'&',''),',',''),'.',''),' - ','-'),'- ','-'),'-','')
                              AND LTRIM( RTRIM( UPPER( BC.QB_FEE ) ) ) = LTRIM( RTRIM( UPPER( OCT.Memo ) ) )
    WHERE
          LTRIM( RTRIM( UPPER( BC.BROKER_NAME_1 ) ) ) != ''
      AND BC.BROKER_NAME_1 IS NOT NULL
      AND OCT.ID IS NOT NULL
        )



go



CREATE VIEW [dbo].[COMMISSION_RESULT_NAME3_PRV]
AS
    (
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
        [dbo].[BROKER_CLIENT_PRV] AS BC
            LEFT JOIN [dbo].[Import_OCT] AS OCT
                      ON
                                  REPLACE( REPLACE( REPLACE( REPLACE( REPLACE(
                                                                              REPLACE( LTRIM( RTRIM( UPPER( BC.BROKER_NAME_2 ) ) ) , '&' , '' ) ,
                                                                              ',' , '' ) , '.' , '' ) , ' - ' , '-' ) ,
                                                    '- ' , '-' ) , '-' , '' ) = REPLACE( REPLACE( REPLACE( REPLACE(
                                                                                                                   REPLACE(
                                                                                                                           REPLACE( LTRIM( RTRIM( UPPER( OCT.Agent ) ) ) , '&' , '' ) ,
                                                                                                                           ',' ,
                                                                                                                           '' ) ,
                                                                                                                   '.' ,
                                                                                                                   '' ) ,
                                                                                                           ' - ' ,
                                                                                                           '-' ) ,
                                                                                                  '- ' , '-' ) , '-' ,
                                                                                         '' )
                              AND REPLACE( REPLACE( REPLACE( REPLACE( REPLACE(
                                                                              REPLACE( LTRIM( RTRIM( UPPER( BC.QB_CLIENT_NAME ) ) ) , '&' , '' ) ,
                                                                              ',' , '' ) , '.' , '' ) , ' - ' , '-' ) ,
                                                    '- ' , '-' ) , '-' , '' ) = REPLACE( REPLACE( REPLACE( REPLACE(
                                                                                                                   REPLACE(
                                                                                                                           REPLACE( LTRIM( RTRIM( UPPER( OCT.[Name] ) ) ) , '&' , '' ) ,
                                                                                                                           ',' ,
                                                                                                                           '' ) ,
                                                                                                                   '.' ,
                                                                                                                   '' ) ,
                                                                                                           ' - ' ,
                                                                                                           '-' ) ,
                                                                                                  '- ' , '-' ) , '-' ,
                                                                                         '' )
                              --LTRIM(RTRIM(UPPER(BC.BROKER_NAME_2))) =  LTRIM(RTRIM(UPPER(OCT.Agent)))
                              --AND  REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(UPPER(BC.QB_CLIENT_NAME))),'&',''),',',''),'.',''),' - ','-'),'- ','-'),'-','') =  REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(UPPER(OCT.[Name]))),'&',''),',',''),'.',''),' - ','-'),'- ','-'),'-','')
                              AND LTRIM( RTRIM( UPPER( BC.QB_FEE ) ) ) = LTRIM( RTRIM( UPPER( OCT.Memo ) ) )
    WHERE
          LTRIM( RTRIM( UPPER( BC.BROKER_NAME_2 ) ) ) != ''
      AND BC.BROKER_NAME_2 IS NOT NULL
      AND OCT.ID IS NOT NULL
        )



go



CREATE VIEW [dbo].[COMMISSION_RESULT_NAME4_PRV]
AS
    (
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
        [dbo].[BROKER_CLIENT_PRV] AS BC
            LEFT JOIN [dbo].[Import_OCT] AS OCT
                      ON
                          --LTRIM(RTRIM(UPPER(BC.BROKER_NAME_4))) =  LTRIM(RTRIM(UPPER(OCT.Agent)))
                                  REPLACE( REPLACE( REPLACE( REPLACE( REPLACE(
                                                                              REPLACE( LTRIM( RTRIM( UPPER( BC.BROKER_NAME_4 ) ) ) , '&' , '' ) ,
                                                                              ',' , '' ) , '.' , '' ) , ' - ' , '-' ) ,
                                                    '- ' , '-' ) , '-' , '' ) = REPLACE( REPLACE( REPLACE( REPLACE(
                                                                                                                   REPLACE(
                                                                                                                           REPLACE( LTRIM( RTRIM( UPPER( OCT.Agent ) ) ) , '&' , '' ) ,
                                                                                                                           ',' ,
                                                                                                                           '' ) ,
                                                                                                                   '.' ,
                                                                                                                   '' ) ,
                                                                                                           ' - ' ,
                                                                                                           '-' ) ,
                                                                                                  '- ' , '-' ) , '-' ,
                                                                                         '' )
                              AND REPLACE( REPLACE( REPLACE( REPLACE( REPLACE(
                                                                              REPLACE( LTRIM( RTRIM( UPPER( BC.QB_CLIENT_NAME ) ) ) , '&' , '' ) ,
                                                                              ',' , '' ) , '.' , '' ) , ' - ' , '-' ) ,
                                                    '- ' , '-' ) , '-' , '' ) = REPLACE( REPLACE( REPLACE( REPLACE(
                                                                                                                   REPLACE(
                                                                                                                           REPLACE( LTRIM( RTRIM( UPPER( OCT.[Name] ) ) ) , '&' , '' ) ,
                                                                                                                           ',' ,
                                                                                                                           '' ) ,
                                                                                                                   '.' ,
                                                                                                                   '' ) ,
                                                                                                           ' - ' ,
                                                                                                           '-' ) ,
                                                                                                  '- ' , '-' ) , '-' ,
                                                                                         '' )
                              AND LTRIM( RTRIM( UPPER( BC.QB_FEE ) ) ) = LTRIM( RTRIM( UPPER( OCT.Memo ) ) )
    WHERE
          LTRIM( RTRIM( UPPER( BC.BROKER_NAME_4 ) ) ) != ''
      AND BC.BROKER_NAME_4 IS NOT NULL
      AND OCT.ID IS NOT NULL
        )



go



CREATE VIEW [dbo].[COMMISSION_RESULT_NAME5_PRV]
AS
    (
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
        [dbo].[BROKER_CLIENT_PRV] AS BC
            LEFT JOIN [dbo].[Import_OCT] AS OCT
                      ON
                          --LTRIM(RTRIM(UPPER(BC.BROKER_NAME_4))) =  LTRIM(RTRIM(UPPER(OCT.Agent)))
                                  REPLACE( REPLACE( REPLACE( REPLACE( REPLACE(
                                                                              REPLACE( LTRIM( RTRIM( UPPER( BC.BROKER_NAME_5 ) ) ) , '&' , '' ) ,
                                                                              ',' , '' ) , '.' , '' ) , ' - ' , '-' ) ,
                                                    '- ' , '-' ) , '-' , '' ) = REPLACE( REPLACE( REPLACE( REPLACE(
                                                                                                                   REPLACE(
                                                                                                                           REPLACE( LTRIM( RTRIM( UPPER( OCT.Agent ) ) ) , '&' , '' ) ,
                                                                                                                           ',' ,
                                                                                                                           '' ) ,
                                                                                                                   '.' ,
                                                                                                                   '' ) ,
                                                                                                           ' - ' ,
                                                                                                           '-' ) ,
                                                                                                  '- ' , '-' ) , '-' ,
                                                                                         '' )
                              AND REPLACE( REPLACE( REPLACE( REPLACE( REPLACE(
                                                                              REPLACE( LTRIM( RTRIM( UPPER( BC.QB_CLIENT_NAME ) ) ) , '&' , '' ) ,
                                                                              ',' , '' ) , '.' , '' ) , ' - ' , '-' ) ,
                                                    '- ' , '-' ) , '-' , '' ) = REPLACE( REPLACE( REPLACE( REPLACE(
                                                                                                                   REPLACE(
                                                                                                                           REPLACE( LTRIM( RTRIM( UPPER( OCT.[Name] ) ) ) , '&' , '' ) ,
                                                                                                                           ',' ,
                                                                                                                           '' ) ,
                                                                                                                   '.' ,
                                                                                                                   '' ) ,
                                                                                                           ' - ' ,
                                                                                                           '-' ) ,
                                                                                                  '- ' , '-' ) , '-' ,
                                                                                         '' )
                              AND LTRIM( RTRIM( UPPER( BC.QB_FEE ) ) ) = LTRIM( RTRIM( UPPER( OCT.Memo ) ) )
    WHERE
          LTRIM( RTRIM( UPPER( BC.BROKER_NAME_5 ) ) ) != ''
      AND BC.BROKER_NAME_5 IS NOT NULL
      AND OCT.ID IS NOT NULL
        )



go



CREATE VIEW [dbo].[COMMISSION_RESULT_NAME6_PRV]
AS
    (
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
        [dbo].[BROKER_CLIENT_PRV] AS BC
            LEFT JOIN [dbo].[Import_OCT] AS OCT
                      ON
                          --LTRIM(RTRIM(UPPER(BC.BROKER_NAME_4))) =  LTRIM(RTRIM(UPPER(OCT.Agent)))
                                  REPLACE( REPLACE( REPLACE( REPLACE( REPLACE(
                                                                              REPLACE( LTRIM( RTRIM( UPPER( BC.BROKER_NAME_6 ) ) ) , '&' , '' ) ,
                                                                              ',' , '' ) , '.' , '' ) , ' - ' , '-' ) ,
                                                    '- ' , '-' ) , '-' , '' ) = REPLACE( REPLACE( REPLACE( REPLACE(
                                                                                                                   REPLACE(
                                                                                                                           REPLACE( LTRIM( RTRIM( UPPER( OCT.Agent ) ) ) , '&' , '' ) ,
                                                                                                                           ',' ,
                                                                                                                           '' ) ,
                                                                                                                   '.' ,
                                                                                                                   '' ) ,
                                                                                                           ' - ' ,
                                                                                                           '-' ) ,
                                                                                                  '- ' , '-' ) , '-' ,
                                                                                         '' )
                              AND REPLACE( REPLACE( REPLACE( REPLACE( REPLACE(
                                                                              REPLACE( LTRIM( RTRIM( UPPER( BC.QB_CLIENT_NAME ) ) ) , '&' , '' ) ,
                                                                              ',' , '' ) , '.' , '' ) , ' - ' , '-' ) ,
                                                    '- ' , '-' ) , '-' , '' ) = REPLACE( REPLACE( REPLACE( REPLACE(
                                                                                                                   REPLACE(
                                                                                                                           REPLACE( LTRIM( RTRIM( UPPER( OCT.[Name] ) ) ) , '&' , '' ) ,
                                                                                                                           ',' ,
                                                                                                                           '' ) ,
                                                                                                                   '.' ,
                                                                                                                   '' ) ,
                                                                                                           ' - ' ,
                                                                                                           '-' ) ,
                                                                                                  '- ' , '-' ) , '-' ,
                                                                                         '' )
                              AND LTRIM( RTRIM( UPPER( BC.QB_FEE ) ) ) = LTRIM( RTRIM( UPPER( OCT.Memo ) ) )
    WHERE
          LTRIM( RTRIM( UPPER( BC.BROKER_NAME_6 ) ) ) != ''
      AND BC.BROKER_NAME_6 IS NOT NULL
      AND OCT.ID IS NOT NULL
        )



go


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


go


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
--WHERE TOTAL != 0
go

go


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



go



CREATE VIEW [dbo].[VW_STATEMENT_PRV]
AS
    (
    SELECT
        [dbo].[STATEMENT_HEADER].[HEADER_ID]
      , [dbo].[STATEMENT_DETAILS].[STATUS] PID
      , [dbo].[STATEMENT_HEADER].[MONTH]
      , [dbo].[STATEMENT_HEADER].[YEAR]
      , [dbo].[STATEMENT_HEADER].[BROKER_ID]
      , [dbo].[STATEMENT_HEADER].[BROKER_NAME]
      , [dbo].[STATEMENT_HEADER].[FLAG]
      , [dbo].[STATEMENT_HEADER].[STATEMENT_TOTAL]
      , [dbo].[STATEMENT_HEADER].[Change_Date]
      , [dbo].[STATEMENT_DETAILS].[QB_CLIENT_NAME]
      , [dbo].[STATEMENT_DETAILS].[CLIENT_NAME]
      , [dbo].[STATEMENT_DETAILS].[QB_FEE]
      , [dbo].[STATEMENT_DETAILS].[FEE_MEMO]
      , [dbo].[STATEMENT_DETAILS].[QUANTITY]
      , [dbo].[STATEMENT_DETAILS].[COMMISSION_RATE]
      , [dbo].[STATEMENT_DETAILS].[UNIT]
      , [dbo].[STATEMENT_DETAILS].[SALES_PRICE]
      , [dbo].[STATEMENT_DETAILS].[TOTAL_PRICE]
      , [dbo].[STATEMENT_DETAILS].[OPEN_BALANCE]
      , [dbo].[STATEMENT_DETAILS].[START_DATE]
      , [dbo].[STATEMENT_DETAILS].[BROKER_STATUS]
    FROM
        [dbo].[STATEMENT_HEADER]
            LEFT JOIN
            [dbo].[STATEMENT_DETAILS] ON [dbo].[STATEMENT_HEADER].HEADER_ID = [dbo].[STATEMENT_DETAILS].HEADER_ID
    
    UNION
    
    SELECT
        [dbo].[STATEMENT_HEADER].[HEADER_ID]
      , '' PID
      , [dbo].[STATEMENT_HEADER].[MONTH]
      , [dbo].[STATEMENT_HEADER].[YEAR]
      , [dbo].[STATEMENT_HEADER].[BROKER_ID]
      , [dbo].[STATEMENT_HEADER].[BROKER_NAME]
      , [dbo].[STATEMENT_HEADER].[FLAG]
      , [dbo].[STATEMENT_HEADER].[STATEMENT_TOTAL]
      , [dbo].[STATEMENT_HEADER].[Change_Date]
      , ''
      , ''
      , ''
      , ''
      , 0
      , 0
      , ''
      , 0
      , 0
      , 0
      , ''
      , ''
    FROM
        [dbo].[STATEMENT_HEADER]
    WHERE
        [dbo].[STATEMENT_HEADER].STATEMENT_TOTAL = 0
        
        )



go
