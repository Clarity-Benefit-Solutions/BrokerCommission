alter table dbo.STATEMENT_HEADER
    add TOTAL numeric(18, 2);

select *
from
    dbo.STATEMENT_HEADER A
ORDER BY
    A.BROKER_NAME;
CREATE VIEW [dbo].[COMMISSION_SUMMARY]
AS
    SELECT DISTINCT
        RT.[BROKER_ID]
      , RT.[BROKER_NAME]
      , RT.PAYLOCITY_ID
    FROM
        [dbo].[COMMISSION_RESULT] AS RT
    GROUP BY
        RT.[BROKER_ID]
      , RT.[BROKER_NAME]
      , RT.PAYLOCITY_ID
go

