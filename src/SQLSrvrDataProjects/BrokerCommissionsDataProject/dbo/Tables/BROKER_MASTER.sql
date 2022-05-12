CREATE TABLE [dbo].[BROKER_MASTER] (
    [ID]                       INT             IDENTITY (1, 1) NOT NULL,
    [BROKER_NAME]              NVARCHAR (500)  NULL,
    [PAYLOCITY_ID]             NVARCHAR (500)  NULL,
    [PREMIUM]                  NUMERIC (18, 2) NULL,
    [EMAIL]                    NVARCHAR (500)  NULL,
    [SECONDARY_EMAIL]          NVARCHAR (500)  NULL,
    [STATUS]                   NVARCHAR (500)  NULL,
    [PREMIUM_TH]               NUMERIC (18, 2) NULL,
    [NOTES]                    NVARCHAR (3000) NULL,
    [BROKER_STATUS]            NVARCHAR (50)   NULL,
    [BROKER_NAME_ID]           NVARCHAR (500)  NULL,
    [BROKER_NAME_1]            NVARCHAR (500)  NULL,
    [BROKER_NAME_2]            NVARCHAR (500)  NULL,
    [BROKER_NAME_3]            NVARCHAR (500)  NULL,
    [BROKER_NAME_4]            NVARCHAR (500)  NULL,
    [BROKER_NAME_5]            NVARCHAR (500)  NULL,
    [BROKER_NAME_6]            NVARCHAR (500)  NULL,
    [BROKER_NAME_ID_FORMATTED] AS              (replace(replace(replace(replace(replace(replace(ltrim(rtrim(upper([BROKER_NAME_ID]))),'&',''),',',''),'.',''),' - ','-'),'- ','-'),'-','')) PERSISTED,
    [BROKER_NAME_FORMATTED]    AS              (replace(replace(replace(replace(replace(replace(ltrim(rtrim(upper([BROKER_NAME]))),'&',''),',',''),'.',''),' - ','-'),'- ','-'),'-','')) PERSISTED,
    [BROKER_NAME_1_FORMATTED]  AS              (replace(replace(replace(replace(replace(replace(ltrim(rtrim(upper([BROKER_NAME_1]))),'&',''),',',''),'.',''),' - ','-'),'- ','-'),'-','')) PERSISTED,
    [BROKER_NAME_2_FORMATTED]  AS              (replace(replace(replace(replace(replace(replace(ltrim(rtrim(upper([BROKER_NAME_2]))),'&',''),',',''),'.',''),' - ','-'),'- ','-'),'-','')) PERSISTED,
    [BROKER_NAME_3_FORMATTED]  AS              (replace(replace(replace(replace(replace(replace(ltrim(rtrim(upper([BROKER_NAME_3]))),'&',''),',',''),'.',''),' - ','-'),'- ','-'),'-','')) PERSISTED,
    [BROKER_NAME_4_FORMATTED]  AS              (replace(replace(replace(replace(replace(replace(ltrim(rtrim(upper([BROKER_NAME_4]))),'&',''),',',''),'.',''),' - ','-'),'- ','-'),'-','')) PERSISTED,
    [BROKER_NAME_5_FORMATTED]  AS              (replace(replace(replace(replace(replace(replace(ltrim(rtrim(upper([BROKER_NAME_5]))),'&',''),',',''),'.',''),' - ','-'),'- ','-'),'-','')) PERSISTED,
    [BROKER_NAME_6_FORMATTED]  AS              (replace(replace(replace(replace(replace(replace(ltrim(rtrim(upper([BROKER_NAME_6]))),'&',''),',',''),'.',''),' - ','-'),'- ','-'),'-','')),
    CONSTRAINT [PK_Broker_i] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [BROKER_NAME]
    ON [dbo].[BROKER_MASTER]([BROKER_NAME] ASC);


GO
CREATE NONCLUSTERED INDEX [BROKER_NAME_1]
    ON [dbo].[BROKER_MASTER]([BROKER_NAME_1] ASC);


GO
CREATE NONCLUSTERED INDEX [BROKER_NAME_2]
    ON [dbo].[BROKER_MASTER]([BROKER_NAME_2] ASC);


GO
CREATE NONCLUSTERED INDEX [BROKER_NAME_3]
    ON [dbo].[BROKER_MASTER]([BROKER_NAME_3] ASC);


GO
CREATE NONCLUSTERED INDEX [BROKER_NAME_4]
    ON [dbo].[BROKER_MASTER]([BROKER_NAME_4] ASC);


GO
CREATE NONCLUSTERED INDEX [BROKER_NAME_5]
    ON [dbo].[BROKER_MASTER]([BROKER_NAME_5] ASC);


GO
CREATE NONCLUSTERED INDEX [BROKER_NAME_6]
    ON [dbo].[BROKER_MASTER]([BROKER_NAME_6] ASC);


GO
CREATE NONCLUSTERED INDEX [PAYLOCITY_ID]
    ON [dbo].[BROKER_MASTER]([PAYLOCITY_ID] ASC);


GO
CREATE NONCLUSTERED INDEX [EMAIL]
    ON [dbo].[BROKER_MASTER]([EMAIL] ASC);


GO
CREATE NONCLUSTERED INDEX [SECONDARY_EMAIL]
    ON [dbo].[BROKER_MASTER]([SECONDARY_EMAIL] ASC);


GO
CREATE NONCLUSTERED INDEX [STATUS]
    ON [dbo].[BROKER_MASTER]([STATUS] ASC);

