use Broker_Commission;
Go;

alter VIEW [dbo].[BROKER_CLIENT] AS (
                                        SELECT
                                            BM.ID
                                          , BM.BROKER_NAME
                                          , REPLACE( BM.BROKER_NAME_ID , '&' , '' ) QB_BROKER_NAME
                                          , CL.CLIENT_NAME
                                          , CL.QB_FEE
                                          , CL.QB_FEE_FORMATTED
                                          , BM.BROKER_STATUS
                                          , BM.EMAIL
                                          , CL.QB_CLIENT_NAME
                                          , CL.QB_CLIENT_NAME_FORMATTED
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
                                          , BM.BROKER_NAME_FORMATTED
                                          , BM.BROKER_NAME_1_FORMATTED
                                          , BM.BROKER_NAME_2_FORMATTED
                                          , BM.BROKER_NAME_3_FORMATTED
                                          , BM.BROKER_NAME_4_FORMATTED
                                          , BM.BROKER_NAME_5_FORMATTED
                                          , BM.BROKER_NAME_6_FORMATTED
                                          , CL.[START_DATE]
                                        FROM
                                            [dbo].[BROKER_MASTER] AS BM
                                                LEFT JOIN [dbo].[CLIENT] AS CL ON BM.ID = CL.BROKER_ID
                                        WHERE
                                            CL.BROKER_ID IS NOT NULL
                                    );

go

