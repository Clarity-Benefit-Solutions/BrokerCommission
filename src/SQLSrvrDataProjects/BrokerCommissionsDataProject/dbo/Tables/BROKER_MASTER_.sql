CREATE TABLE [dbo].[BROKER_MASTER_] (
    [ID]             INT             IDENTITY (1, 1) NOT NULL,
    [BROKER_NAME]    VARCHAR (500)   NULL,
    [BROKER_GROUP]   INT             NULL,
    [PREMIUM]        INT             NULL,
    [CREATE_DATE]    DATETIME        NULL,
    [EMAIL]          VARCHAR (50)    NULL,
    [STATUS]         NVARCHAR (50)   NULL,
    [PREMIUM_TH]     NUMERIC (18, 2) NULL,
    [NOTES]          NVARCHAR (MAX)  NULL,
    [PAYLOCITY_ID]   INT             NULL,
    [BROKER_NAME_ID] VARCHAR (500)   NULL,
    CONSTRAINT [PK_Broker] PRIMARY KEY CLUSTERED ([ID] ASC)
);

