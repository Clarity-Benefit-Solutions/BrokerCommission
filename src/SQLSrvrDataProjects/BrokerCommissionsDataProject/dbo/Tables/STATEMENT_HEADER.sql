CREATE TABLE [dbo].[STATEMENT_HEADER] (
    [HEADER_ID]                    INT             IDENTITY (1, 1) NOT NULL,
    [MONTH]                        VARCHAR (50)    NOT NULL,
    [YEAR]                         INT             NOT NULL,
    [BROKER_ID]                    INT             NULL,
    [BROKER_NAME]                  NVARCHAR (500)  NULL,
    [FLAG]                         INT             NOT NULL,
    [STATEMENT_TOTAL]              NUMERIC (18, 2) NULL,
    [Change_Date]                  DATETIME        NULL,
    [STATEMENT_PENDING_TOTAL]      NUMERIC (18, 2) NULL,
    [STATEMENT_ALREADY_PAID_TOTAL] NUMERIC (18, 2) NULL,
    CONSTRAINT [PK_STATEMENT_HEADER] PRIMARY KEY CLUSTERED ([HEADER_ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [HEADER_ID]
    ON [dbo].[STATEMENT_HEADER]([HEADER_ID] ASC);


GO
CREATE NONCLUSTERED INDEX [BROKER_ID]
    ON [dbo].[STATEMENT_HEADER]([BROKER_ID] ASC);


GO
CREATE NONCLUSTERED INDEX [MONTH]
    ON [dbo].[STATEMENT_HEADER]([MONTH] ASC);


GO
CREATE NONCLUSTERED INDEX [YEAR]
    ON [dbo].[STATEMENT_HEADER]([YEAR] ASC);


GO
CREATE NONCLUSTERED INDEX [FLAG]
    ON [dbo].[STATEMENT_HEADER]([FLAG] ASC);

