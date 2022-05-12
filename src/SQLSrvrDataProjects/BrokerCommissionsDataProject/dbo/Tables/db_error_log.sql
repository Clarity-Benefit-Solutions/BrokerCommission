CREATE TABLE [dbo].[db_error_log] (
    [log_id]     INT            IDENTITY (1, 1) NOT NULL,
    [sql_state]  NVARCHAR (200) NULL,
    [err_no]     NVARCHAR (50)  NULL,
    [err_source] NVARCHAR (500) NULL,
    [err_msg]    TEXT           NULL,
    [created_at] DATETIME       DEFAULT (getdate()) NOT NULL,
    [created_by] NVARCHAR (200) DEFAULT (user_name()) NULL,
    PRIMARY KEY CLUSTERED ([log_id] ASC)
);

