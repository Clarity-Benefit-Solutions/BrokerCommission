CREATE TABLE [dbo].[FEE_MEMO] (
    [ID]            INT             IDENTITY (1, 1) NOT NULL,
    [MEMO]          NVARCHAR (255)  NULL,
    [COMMISIONABLE] INT             NULL,
    [CLIENT_ID]     INT             NULL,
    [NOTE]          NVARCHAR (255)  NULL,
    [RATE]          DECIMAL (18, 2) NULL,
    CONSTRAINT [PK_Memo_Name] PRIMARY KEY CLUSTERED ([ID] ASC)
);

