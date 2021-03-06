CREATE TABLE [dbo].[STATEMENT_DETAILS_BK] (
    [DETAIL_ID]       INT             IDENTITY (1, 1) NOT NULL,
    [HEADER_ID]       INT             NOT NULL,
    [INVOICE_DATE]    DATE            NULL,
    [INVOICE_NUM]     NVARCHAR (500)  NULL,
    [QB_CLIENT_NAME]  NVARCHAR (500)  NULL,
    [CLIENT_NAME]     NVARCHAR (500)  NULL,
    [BROKER_ID]       INT             NULL,
    [BROKER_NAME]     NVARCHAR (500)  NULL,
    [QB_FEE]          NVARCHAR (500)  NULL,
    [FEE_MEMO]        NVARCHAR (500)  NULL,
    [QUANTITY]        INT             NULL,
    [COMMISSION_RATE] NUMERIC (18, 2) NULL,
    [UNIT]            NVARCHAR (50)   NULL,
    [STATUS]          NVARCHAR (50)   NULL,
    [SALES_PRICE]     NUMERIC (18, 2) NULL,
    [TOTAL_PRICE]     NUMERIC (18, 2) NULL,
    [START_DATE]      NVARCHAR (50)   NULL,
    [BROKER_STATUS]   NVARCHAR (50)   NULL,
    [OPEN_BALANCE]    NUMERIC (18, 2) NULL
);

