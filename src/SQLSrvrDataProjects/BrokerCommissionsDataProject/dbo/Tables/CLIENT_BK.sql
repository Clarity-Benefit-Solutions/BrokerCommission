CREATE TABLE [dbo].[CLIENT_BK] (
    [CLIENT_ID]       INT             IDENTITY (1, 1) NOT NULL,
    [QB_CLIENT_NAME]  NVARCHAR (500)  NULL,
    [CLIENT_NAME]     NVARCHAR (500)  NULL,
    [BROKER_ID]       INT             NULL,
    [QB_FEE]          NVARCHAR (500)  NULL,
    [FEE_MEMO]        NVARCHAR (500)  NULL,
    [COMMISSION_RATE] NUMERIC (18, 2) NULL,
    [UNIT]            NVARCHAR (50)   NULL,
    [STATUS]          NVARCHAR (50)   NULL,
    [FEE]             NVARCHAR (50)   NULL,
    [START_DATE]      NVARCHAR (50)   NULL
);

