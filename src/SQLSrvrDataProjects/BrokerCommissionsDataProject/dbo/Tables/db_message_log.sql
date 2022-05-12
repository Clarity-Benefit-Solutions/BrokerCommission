CREATE TABLE [dbo].[db_message_log] (
    [log_id]     INT            IDENTITY (1, 1) NOT NULL,
    [log_level]  NVARCHAR (200) NULL,
    [log_source] NVARCHAR (500) NULL,
    [log_msg]    TEXT           NULL,
    [created_at] DATETIME       DEFAULT (getdate()) NOT NULL,
    [created_by] NVARCHAR (200) DEFAULT (user_name()) NULL,
    PRIMARY KEY CLUSTERED ([log_id] ASC)
);

