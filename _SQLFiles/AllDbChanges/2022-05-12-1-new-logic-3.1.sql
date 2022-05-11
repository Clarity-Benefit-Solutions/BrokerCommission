use Broker_Commission;
Go;

CREATE TABLE [dbo].[db_error_log](
	[log_id] [int] IDENTITY(1,1) NOT NULL,
	[sql_state] [nvarchar](200) NULL,
	[err_no] [nvarchar](50) NULL,
	[err_source] [nvarchar](500) NULL,
	[err_msg] [text] NULL,
	[created_at] [datetime] NOT NULL,
	[created_by] [nvarchar](200) NULL,
PRIMARY KEY CLUSTERED
(
	[log_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

ALTER TABLE [dbo].[db_error_log] ADD  DEFAULT (getdate()) FOR [created_at]
GO

ALTER TABLE [dbo].[db_error_log] ADD  DEFAULT (user_name()) FOR [created_by]
GO

CREATE TABLE [dbo].[db_message_log](
	[log_id] [int] IDENTITY(1,1) NOT NULL,
	[log_level] [nvarchar](200) NULL,
	[log_source] [nvarchar](500) NULL,
	[log_msg] [text] NULL,
	[created_at] [datetime] NOT NULL,
	[created_by] [nvarchar](200) NULL,
PRIMARY KEY CLUSTERED
(
	[log_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

ALTER TABLE [dbo].[db_message_log] ADD  DEFAULT (getdate()) FOR [created_at]
GO

ALTER TABLE [dbo].[db_message_log] ADD  DEFAULT (user_name()) FOR [created_by]
GO


CREATE PROCEDURE [dbo].[db_log_message](
                                   @msg_source nvarchar(200),
                                   @msg text,
                                   @log_level nvarchar(50),
                                   @recsaffected int = NULL,
                                   @print int = 1 ) AS
BEGIN
    BEGIN TRY
        DECLARE @recsaffected2 nvarchar(100) = IIF( ISNULL( @recsaffected , '' ) = '-1' , '' ,
                                                    CAST( @recsaffected AS nvarchar ) );
        DECLARE @msg1 nvarchar(max) = CONCAT( '**LOG** ' , 'RECSAFFECTED: ' , @recsaffected2 , ', FROM : ' ,
                                              @msg_source , ', MESSAGE : ' , @msg );
        IF @print > 0
            RAISERROR (@msg1, 0, 1) WITH NOWAIT
        /**/
        INSERT
            INTO db_message_log (
                                log_level,
                                log_source,
                                log_msg
        )
        VALUES (
               @log_level,
               @msg_source,
               CONCAT( @msg , ', RecsAffected : ' , @recsaffected2 )
               );
    END TRY BEGIN CATCH
        INSERT
            INTO dbo.db_error_log(
                                 sql_state,
                                 err_no,
                                 err_source,
                                 err_msg
        )
        VALUES (
               ERROR_SEVERITY( ),
               '' + ERROR_NUMBER( ),
               ERROR_PROCEDURE( ),
               CAST( ERROR_LINE( ) AS nvarchar ) + ' - ' + ERROR_MESSAGE( )
               );
    END CATCH
END;
GO



CREATE PROCEDURE [dbo].[db_log_error](
                                @err_no varchar(50),
                                @err_source varchar(200),
                                @err_msg text,
                                @sqlstate varchar(200) ) AS
BEGIN
    PRINT CONCAT( '****ERROR**** ' , ', SQLSTATE: ' , @sqlstate , ', ERRNO: ' , @err_no , ', FROM: ' , @err_source ,
                  ', MESSAGE: ' , @err_msg );
    /**/
    INSERT
        INTO db_error_log (
                          sql_state,
                          err_no,
                          err_source,
                          err_msg
    )
    VALUES (
           @sqlstate,
           @err_no,
           @err_source,
           @err_msg
           );
END;
GO



CREATE PROCEDURE [dbo].[db_throw_error](
                                  @err_no nvarchar(50),
                                  @err_source nvarchar(200),
                                  @err_msg nvarchar(2000) ) AS
BEGIN
    DECLARE @err_src_msg nvarchar(2000);
    SET @err_src_msg = CONCAT( 'ERROR ' , @err_source , ' : ' , @err_msg );
    -- log error
    EXEC db_log_error @err_no , @err_source , @err_msg , '45000';
    THROW @err_no, @err_src_msg, 1;
END
GO
