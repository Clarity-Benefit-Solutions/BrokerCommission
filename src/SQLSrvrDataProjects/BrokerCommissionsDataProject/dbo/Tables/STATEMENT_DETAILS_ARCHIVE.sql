CREATE TABLE [dbo].[STATEMENT_DETAILS_ARCHIVE] (
    [ARCHIVE_DETAIL_ID]   INT             IDENTITY (1, 1) NOT NULL,
    [DETAIL_ID]           INT             NOT NULL,
    [HEADER_ID]           INT             NOT NULL,
    [INVOICE_DATE]        DATE            NULL,
    [INVOICE_NUM]         NVARCHAR (500)  NULL,
    [QB_CLIENT_NAME]      NVARCHAR (500)  NULL,
    [CLIENT_NAME]         NVARCHAR (500)  NULL,
    [BROKER_ID]           INT             NULL,
    [BROKER_NAME]         NVARCHAR (500)  NULL,
    [QB_FEE]              NVARCHAR (500)  NULL,
    [FEE_MEMO]            NVARCHAR (500)  NULL,
    [QUANTITY]            INT             NULL,
    [COMMISSION_RATE]     NUMERIC (18, 2) NULL,
    [UNIT]                NVARCHAR (50)   NULL,
    [STATUS]              NVARCHAR (50)   NULL,
    [SALES_PRICE]         NUMERIC (18, 2) NULL,
    [TOTAL_PRICE]         NUMERIC (18, 2) NULL,
    [START_DATE]          NVARCHAR (50)   NULL,
    [BROKER_STATUS]       NVARCHAR (50)   NULL,
    [OPEN_BALANCE]        NUMERIC (18, 2) NULL,
    [month]               VARCHAR (50)    NULL,
    [year]                INT             NULL,
    [line_payment_status] VARCHAR (100)   DEFAULT (NULL) NULL,
    CONSTRAINT [PK_STATEMENT_DETAILS_ARCHIVE] PRIMARY KEY CLUSTERED ([ARCHIVE_DETAIL_ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [HEADER_ID]
    ON [dbo].[STATEMENT_DETAILS_ARCHIVE]([HEADER_ID] ASC);


GO
CREATE NONCLUSTERED INDEX [QB_CLIENT_NAME]
    ON [dbo].[STATEMENT_DETAILS_ARCHIVE]([QB_CLIENT_NAME] ASC);


GO
CREATE NONCLUSTERED INDEX [CLIENT_NAME]
    ON [dbo].[STATEMENT_DETAILS_ARCHIVE]([CLIENT_NAME] ASC);


GO
CREATE NONCLUSTERED INDEX [BROKER_ID]
    ON [dbo].[STATEMENT_DETAILS_ARCHIVE]([BROKER_ID] ASC);


GO
CREATE NONCLUSTERED INDEX [BROKER_NAME]
    ON [dbo].[STATEMENT_DETAILS_ARCHIVE]([BROKER_NAME] ASC);


GO
CREATE NONCLUSTERED INDEX [month]
    ON [dbo].[STATEMENT_DETAILS_ARCHIVE]([month] ASC);


GO
CREATE NONCLUSTERED INDEX [year]
    ON [dbo].[STATEMENT_DETAILS_ARCHIVE]([year] ASC);

