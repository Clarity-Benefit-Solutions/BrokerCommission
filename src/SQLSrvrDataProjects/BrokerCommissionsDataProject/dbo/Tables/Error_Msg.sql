CREATE TABLE [dbo].[Error_Msg] (
    [ID]                                   INT           IDENTITY (1, 1) NOT NULL,
    [Flat File Source Error Output Column] VARCHAR (MAX) NULL,
    [ErrorCode]                            INT           NULL,
    [ErrorColumn]                          INT           NULL,
    CONSTRAINT [PK_Error_Msg] PRIMARY KEY CLUSTERED ([ID] ASC)
);

