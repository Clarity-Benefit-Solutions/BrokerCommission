use Broker_Commission;

/* 1. bind broker selection driop down*/

/* 2. bind brokers grid - showing all non archived (not emails sent) */
SELECT
    H.HEADER_ID
  , A.BROKER_ID
  , A.BROKER_NAME
  , A.PAYLOCITY_ID
  , A.TOTAL
FROM
    [dbo].[COMMISSION_SUMMARY] AS A
        LEFT JOIN
        [dbo].[STATEMENT_HEADER] AS H ON A.BROKER_ID = H.BROKER_ID
WHERE
    H.FLAG != 3;

/* 2. send email and archive
   SendEmails.aspx
*/

select *
from
    dbo.STATEMENT_HEADER
Where
      MONTH = 'March'
  and year = '2022'
  and BROKER_ID != null
  and (FLAG == 0 or x.FLAG == 4)
order by
    STATEMENT_HEADER.BROKER_ID;

/*
 -- generate pdf and save to path
 string outputPath = ReportHelper.CreatedWord(headerID);
*/

/* generate statement details*/
exec SP_STATEMENT_DETAIL_UPDATE;

/* A. take 2 lists
    var list = db.STATEMENT_DETAILS.Where(x => x.HEADER_ID == statementID && x.OPEN_BALANCE == 0).OrderBy(x => x.CLIENT_NAME).ToList();
   
    var list_pending = db.STATEMENT_DETAILS.Where(x => x.HEADER_ID == statementID && x.OPEN_BALANCE != 0).OrderBy(x => x.CLIENT_NAME).ToList();
    
   */

/*
send email with attachment
util.email_send_with_attachment(from, to, outputPath, item.BROKER_NAME, item.MONTH, item.YEAR);
*/
