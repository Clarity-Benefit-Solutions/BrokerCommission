CREATE TABLE [dbo].[Detail_Input] (
    [ID]           INT             IDENTITY (1, 1) NOT NULL,
    [Type]         NVARCHAR (255)  NULL,
    [Date]         DATETIME        NULL,
    [Num]          NVARCHAR (255)  NULL,
    [Name]         NVARCHAR (255)  NULL,
    [Memo]         NVARCHAR (3000) NULL,
    [Agent]        NVARCHAR (255)  NULL,
    [Qty]          INT             NULL,
    [Sales Price]  NUMERIC (18, 2) NULL,
    [Amount]       NUMERIC (18, 2) NULL,
    [Open Balance] NUMERIC (18, 2) NULL,
    CONSTRAINT [PK_Detail_Input] PRIMARY KEY CLUSTERED ([ID] ASC)
);

