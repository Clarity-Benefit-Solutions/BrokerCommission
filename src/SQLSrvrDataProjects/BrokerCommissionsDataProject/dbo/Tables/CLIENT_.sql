CREATE TABLE [dbo].[CLIENT_] (
    [CLIENT_ID]       INT             IDENTITY (1, 1) NOT NULL,
    [CLIENT_NAME]     VARCHAR (50)    NULL,
    [BROKER_ID]       INT             NULL,
    [FEE]             VARCHAR (500)   NULL,
    [FEE_MEMO]        VARCHAR (50)    NULL,
    [COMMISSION_RATE] NUMERIC (18, 2) NULL,
    [UNIT]            NVARCHAR (50)   NULL,
    [STATUS]          NVARCHAR (50)   NULL,
    CONSTRAINT [PK_Agent_Master] PRIMARY KEY CLUSTERED ([CLIENT_ID] ASC)
);

