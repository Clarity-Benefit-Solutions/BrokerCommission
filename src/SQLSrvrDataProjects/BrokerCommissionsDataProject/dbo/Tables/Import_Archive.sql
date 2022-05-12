CREATE TABLE [dbo].[Import_Archive] (
    [ArchiveID]       INT             IDENTITY (1, 1) NOT NULL,
    [ID]              INT             NOT NULL,
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
    [NUM_FORMATTED]   VARCHAR (1000)  NULL,
    [memo_FORMATTED]  VARCHAR (1000)  NULL,
    [Agent_FORMATTED] VARCHAR (1000)  NULL,
    [Name_FORMATTED]  VARCHAR (1000)  NULL,
    [created_at]      DATETIME        NULL,
    [statement_month] VARCHAR (50)    NULL,
    [statement_year]  VARCHAR (50)    NULL,
    [is_deleted]      INT             DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Import_Archive] PRIMARY KEY CLUSTERED ([ArchiveID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [id]
    ON [dbo].[Import_Archive]([ID] ASC);


GO
CREATE NONCLUSTERED INDEX [NUM_FORMATTED]
    ON [dbo].[Import_Archive]([NUM_FORMATTED] ASC);


GO
CREATE NONCLUSTERED INDEX [Agent_FORMATTED]
    ON [dbo].[Import_Archive]([Agent_FORMATTED] ASC);


GO
CREATE NONCLUSTERED INDEX [Name_FORMATTED]
    ON [dbo].[Import_Archive]([Name_FORMATTED] ASC);


GO
CREATE NONCLUSTERED INDEX [memo_FORMATTED]
    ON [dbo].[Import_Archive]([memo_FORMATTED] ASC);


GO
CREATE NONCLUSTERED INDEX [statement_month]
    ON [dbo].[Import_Archive]([statement_month] ASC);


GO
CREATE NONCLUSTERED INDEX [statement_year]
    ON [dbo].[Import_Archive]([statement_year] ASC);


GO
CREATE NONCLUSTERED INDEX [is_deleted]
    ON [dbo].[Import_Archive]([is_deleted] ASC);

