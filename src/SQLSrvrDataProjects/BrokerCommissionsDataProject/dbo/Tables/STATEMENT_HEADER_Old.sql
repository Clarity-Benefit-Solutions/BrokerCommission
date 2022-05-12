CREATE TABLE [dbo].[STATEMENT_HEADER_Old] (
    [HEADER_ID]       INT             IDENTITY (1, 1) NOT NULL,
    [MONTH]           VARCHAR (50)    NOT NULL,
    [YEAR]            INT             NOT NULL,
    [BROKER_ID]       INT             NULL,
    [BROKER_NAME]     NVARCHAR (500)  NULL,
    [FLAG]            INT             NOT NULL,
    [STATEMENT_TOTAL] NUMERIC (18, 2) NULL,
    [Change_Date]     DATETIME        NULL,
    CONSTRAINT [PK_STATEMENT_HEADER_Old] PRIMARY KEY CLUSTERED ([HEADER_ID] ASC)
);

