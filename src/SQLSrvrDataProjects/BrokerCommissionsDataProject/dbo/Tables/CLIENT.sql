CREATE TABLE [dbo].[CLIENT] (
    [CLIENT_ID]                INT             IDENTITY (1, 1) NOT NULL,
    [QB_CLIENT_NAME]           NVARCHAR (500)  NULL,
    [CLIENT_NAME]              NVARCHAR (500)  NULL,
    [BROKER_ID]                INT             NULL,
    [QB_FEE]                   NVARCHAR (500)  NULL,
    [FEE_MEMO]                 NVARCHAR (500)  NULL,
    [COMMISSION_RATE]          NUMERIC (18, 2) NULL,
    [UNIT]                     NVARCHAR (50)   NULL,
    [STATUS]                   NVARCHAR (50)   NULL,
    [FEE]                      NVARCHAR (50)   NULL,
    [START_DATE]               NVARCHAR (50)   NULL,
    [QB_CLIENT_NAME_FORMATTED] AS              (replace(replace(replace(replace(replace(replace(ltrim(rtrim(upper([QB_CLIENT_NAME]))),'&',''),',',''),'.',''),' - ','-'),'- ','-'),'-','')),
    [QB_FEE_FORMATTED]         AS              (ltrim(rtrim(upper([QB_FEE])))) PERSISTED,
    CONSTRAINT [PK_CLIENT_IMPORT_10222021] PRIMARY KEY CLUSTERED ([CLIENT_ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [QB_FEE_FORMATTED_FORMATTED]
    ON [dbo].[CLIENT]([QB_FEE_FORMATTED] ASC);


GO
CREATE NONCLUSTERED INDEX [QB_CLIENT_NAME_FORMATTED]
    ON [dbo].[CLIENT]([QB_CLIENT_NAME_FORMATTED] ASC);

