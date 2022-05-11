CREATE PROCEDURE [dbo].[SP_IMPORT_FILE_SENT_SSIS]
    
    -- Add the parameters for the stored procedure here

@Month nvarchar(30),
@Year int
AS

BEGIN
    SET NOCOUNT ON;
    
    -- update sdtatement month and year
    
    -- delete from import_archive
    delete
    from
        dbo.Import_Archive
    where
          statement_month = @Month
      and statement_month = @Year;
    
    --     insert new records into import_archive
    insert into dbo.Import_Archive (
                                   ID,
                                   Type,
                                   Date,
                                   Num,
                                   Name,
                                   Memo,
                                   Agent,
                                   Qty,
                                   [Sales Price],
                                   Amount,
                                   [Open Balance],
                                   NUM_FORMATTED,
                                   memo_FORMATTED,
                                   Agent_FORMATTED,
                                   Name_FORMATTED,
                                   created_at,
                                   statement_month,
                                   statement_year
    )
    select
        ID
      , Type
      , Date
      , Num
      , Name
      , Memo
      , Agent
      , Qty
      , [Sales Price]
      , Amount
      , [Open Balance]
      , NUM_FORMATTED
      , memo_FORMATTED
      , Agent_FORMATTED
      , Name_FORMATTED
      , created_at
      , statement_month
      , statement_year
    from
        dbo.Import_Oct
    where
          statement_month = @Month
      and statement_month = @Year;
    
    DELETE
    FROM
        [dbo].[STATEMENT_HEADER]
    WHERE
          [MONTH] = @Month
      AND [YEAR] = @Year
    -- insert one row per distinct broker in Import_Current
    INSERT INTO [dbo].[STATEMENT_HEADER]
    (
    [MONTH],
    [YEAR],
    [BROKER_ID],
    [BROKER_NAME],
    [FLAG],
    [STATEMENT_TOTAL],
    [Change_Date]
    )
    SELECT
        @Month
      , @Year
      , RT.[BROKER_ID]
      , RT.[BROKER_NAME]
      , RT.PAYLOCITY_ID
    FROM
        [dbo].[COMMISSION_RESULT] AS RT
    WHERE
          isnull( RT.[BROKER_NAME] , '' ) != ''
      AND isnull( RT.BROKER_ID , '' ) != ''
    GROUP BY
        RT.[BROKER_ID]
      , RT.[BROKER_NAME]
      , RT.PAYLOCITY_ID

END
go

