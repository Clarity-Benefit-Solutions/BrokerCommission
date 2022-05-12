CREATE TABLE [dbo].[Import_OCT] (
    [ID]              INT             IDENTITY (1, 1) NOT NULL,
    [Type]            VARCHAR (50)    NULL,
    [Date]            DATETIME        NULL,
    [Num]             VARCHAR (3000)  NULL,
    [Name]            VARCHAR (3000)  NULL,
    [Memo]            VARCHAR (3000)  NULL,
    [Agent]           VARCHAR (500)   NULL,
    [Qty]             INT             NULL,
    [Sales Price]     NUMERIC (18, 2) NULL,
    [Amount]          NUMERIC (18, 2) NULL,
    [Open Balance]    NUMERIC (18, 2) NULL,
    [NUM_FORMATTED]   AS              (ltrim(rtrim(upper([Num])))) PERSISTED,
    [memo_FORMATTED]  AS              (ltrim(rtrim(upper([Memo])))) PERSISTED,
    [Agent_FORMATTED] AS              (replace(replace(replace(replace(replace(replace(ltrim(rtrim(upper([Agent]))),'&',''),',',''),'.',''),' - ','-'),'- ','-'),'-','')) PERSISTED,
    [Name_FORMATTED]  AS              (replace(replace(replace(replace(replace(replace(ltrim(rtrim(upper([Name]))),'&',''),',',''),'.',''),' - ','-'),'- ','-'),'-','')) PERSISTED,
    [created_at]      DATETIME        DEFAULT (getdate()) NULL,
    [statement_month] VARCHAR (50)    NULL,
    [statement_year]  VARCHAR (50)    NULL,
    [is_deleted]      INT             DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Import_OCT_2] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NUM_FORMATTED]
    ON [dbo].[Import_OCT]([NUM_FORMATTED] ASC);


GO
CREATE NONCLUSTERED INDEX [Agent_FORMATTED]
    ON [dbo].[Import_OCT]([Agent_FORMATTED] ASC);


GO
CREATE NONCLUSTERED INDEX [Name_FORMATTED]
    ON [dbo].[Import_OCT]([Name_FORMATTED] ASC);


GO
CREATE NONCLUSTERED INDEX [memo_FORMATTED]
    ON [dbo].[Import_OCT]([memo_FORMATTED] ASC);


GO
CREATE NONCLUSTERED INDEX [statement_month]
    ON [dbo].[Import_OCT]([statement_month] ASC);


GO
CREATE NONCLUSTERED INDEX [statement_year]
    ON [dbo].[Import_OCT]([statement_year] ASC);


GO
CREATE NONCLUSTERED INDEX [is_deleted]
    ON [dbo].[Import_OCT]([is_deleted] ASC);

