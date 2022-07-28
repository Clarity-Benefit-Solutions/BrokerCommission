use Broker_Commission;
go


alter table Statement_Details
    add constraint Statement_Details_Broker_Master__fk
        foreign key (BROKER_ID)
            references Broker_Master (ID)
go

alter table dbo.Client_Memo_Broker
    add MEMO_FORMATTED
        as
            REPLACE(
                    REPLACE(
                            REPLACE(
                                    REPLACE(
                                            REPLACE(
                                                    REPLACE(
                                                            LTRIM(
                                                                    RTRIM(
                                                                            UPPER(
                                                                                    isnull( MEMO , '' ) )
                                                                        )
                                                                ) , '&' , '' ) ,
                                                    ',' , '' ) ,
                                            '.' , '' ) ,
                                    '- ' , '-' ) ,
                            '- ' , '-' ) ,
                    '-' , '' )
            PERSISTED;

go
create index MEMO_FORMATTED on dbo.Client_Memo_Broker (MEMO_FORMATTED);

go

CREATE or alter VIEW [dbo].[BROKER_CLIENT]
AS
    (
    SELECT
        BM.ID
      , BM.BROKER_NAME
      , REPLACE( BM.BROKER_NAME_ID , '&' , '' ) QB_BROKER_NAME
      , BM.BROKER_NAME_ID_FORMATTED QB_BROKER_NAME_FORMATTED
      , CL.CLIENT_NAME
      , memo QB_FEE
      , cmb.MEMO_FORMATTED QB_FEE_FORMATTED
      , BM.BROKER_STATUS
      , BM.EMAIL
      , CL.QB_CLIENT_NAME
      , CL.QB_CLIENT_NAME_FORMATTED
      , MEMO
      , COMMISSION_RATE
      , UNIT
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
      , CL.CLIENT_ID
    FROM
        [dbo].[BROKER_MASTER] AS BM
            left join dbo.Client_Memo_Broker cmb on bm.ID = cmb.BROKER_ID
            LEFT JOIN [dbo].[CLIENT] AS CL ON cmb.CLIENT_ID = CL.CLIENT_ID
        )
go



