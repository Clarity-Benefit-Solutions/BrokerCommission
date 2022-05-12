﻿CREATE TABLE [dbo].[BROKER_COMMISSION] (
    [ID]               INT             IDENTITY (1, 1) NOT NULL,
    [PERIOD]           VARCHAR (50)    NULL,
    [BROKER_ID]        INT             NULL,
    [BROKER_NAME]      VARCHAR (500)   NULL,
    [PAYLOCITY_NUMBER] INT             NULL,
    [PAYMENT_AMOUNT]   NUMERIC (18, 2) NULL,
    CONSTRAINT [PK_BROKER_COMMISSION] PRIMARY KEY CLUSTERED ([ID] ASC)
);
