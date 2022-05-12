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