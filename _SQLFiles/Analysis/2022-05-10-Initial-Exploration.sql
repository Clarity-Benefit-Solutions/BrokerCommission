use Broker_Commission;

go

/*A  UI: user clicks Upload Raw Data*/
/* 1. call SP_FILE_IMPORT_SSIS */
/* 1.1 this call SP_UPLODADFILE*/
/* 1.1.1 this call job Broker_Commission which
   truncates table Import_OCT
   imports file from "E:\BROKER_COMMISSION_OUTPUT\file_import.csv" in same machine as sql server into table Import_OCT*/
select *
from
    dbo.Import_OCT;
GO
/*
-- ENHANCEMNT: fix columns by running new Sp
update [dbo].[BROKER_CLIENT]
set
    QB_BROKER_NAME = LTRIM( RTRIM( UPPER( REPLACE( QB_BROKER_NAME , '&' , '' ) ) ) ),
    QB_CLIENT_NAME = REPLACE( REPLACE( REPLACE( REPLACE( REPLACE(
                                                                 REPLACE( LTRIM( RTRIM( UPPER( QB_CLIENT_NAME ) ) ) , '&' , '' ) ,
                                                                 ',' , '' ) , '.' , '' ) , ' - ' , '-' ) , '- ' ,
                                       '-' ) , '-' , '' ),
    QB_FEE         = LTRIM( RTRIM( UPPER( QB_FEE ) ) );

--
;
update dbo.Import_OCT
set
    Agent= REPLACE( REPLACE( REPLACE( REPLACE(
                                              REPLACE( REPLACE( LTRIM( RTRIM( UPPER( Agent ) ) ) , '&' , '' ) , ',' , '' ) ,
                                              '.' , '' ) , ' - ' , '-' ) , '- ' , '-' ) , '-' , '' )
  , [Name] = REPLACE( REPLACE( REPLACE( REPLACE(
                                                REPLACE( REPLACE( LTRIM( RTRIM( UPPER( [Name] ) ) ) , '&' , '' ) , ',' ,
                                                         '' ) , '.' , '' ) , ' - ' , '-' ) , '- ' , '-' ) , '-' , '' )
  , memo = LTRIM( RTRIM( UPPER( Memo ) ) );
 */
go

/* Code calls statement_process(string Month, int year)
   
    query = "EXEC [dbo].[SP_IMPORT_FILE_SENT_SSIS] @Month='" + Month + "', @Year='" + year + "'";
   
   */
EXEC [dbo].[SP_IMPORT_FILE_SENT_SSIS] @Month='March' , @Year='2022';
/* inserts into statement header from COMMISSION_SUMMARY - one row per bromker with totals
     RT.[BROKER_ID]
                  , RT.[BROKER_NAME]
                  , RT.PAYLOCITY_ID, total(COMMISSION AMOUNT)
   
   ( CASE
	WHEN BC.UNIT ='Per Qt' THEN BC.COMMISSION_RATE * OCT.Qty
	WHEN BC.UNIT ='Per Amount'  THEN BC.COMMISSION_RATE * OCT.Amount
	WHEN BC.UNIT ='Flat Rate'  THEN BC.COMMISSION_RATE
	END ) AS [COMMISSION AMOUNT]
   
   deletes
   */
go
select *
from
    [STATEMENT_HEADER];
go


/* WHERE LTRIM(RTRIM(UPPER(BC.QB_BROKER_NAME))) != ''  AND OCT.ID IS NOT NULL */
select *
from
    [dbo].[COMMISSION_RESULT_NAME0];

/* WHERE LTRIM(RTRIM(UPPER(BC.BROKER_NAME_3))) != ''  AND BC.BROKER_NAME_3 IS NOT NULL AND OCT.ID IS NOT NULL */
select *
from
    [dbo].[COMMISSION_RESULT_NAME1];

/* WHERE LTRIM(RTRIM(UPPER(BC.BROKER_NAME_1))) != ''  AND BC.BROKER_NAME_1 IS NOT NULL AND OCT.ID IS NOT NULL */
select *
from
    [dbo].[COMMISSION_RESULT_NAME2];

/* WHERE LTRIM(RTRIM(UPPER(BC.BROKER_NAME_2))) != ''  AND BC.BROKER_NAME_2 IS NOT NULL AND OCT.ID IS NOT NULL*/
select *
from
    [dbo].[COMMISSION_RESULT_NAME3];

/* WHERE LTRIM(RTRIM(UPPER(BC.BROKER_NAME_4))) != ''  AND BC.BROKER_NAME_4 IS NOT NULL AND OCT.ID IS NOT NULL */
select *
from
    [dbo].[COMMISSION_RESULT_NAME4];

/* WHERE LTRIM(RTRIM(UPPER(BC.BROKER_NAME_5))) != ''  AND BC.BROKER_NAME_5 IS NOT NULL AND OCT.ID IS NOT NULL */
select *
from
    [dbo].[COMMISSION_RESULT_NAME5];

/* WHERE LTRIM(RTRIM(UPPER(BC.BROKER_NAME_6))) != ''  AND BC.BROKER_NAME_6 IS NOT NULL AND OCT.ID IS NOT NULL */
select *
from
    [dbo].[COMMISSION_RESULT_NAME6];

select *
from
    [dbo].[STATEMENT_DETAILS_ADD];
/*
 SELECT * FROM [dbo].[COMMISSION_RESULT_NAME0]
	 UNION
	 SELECT * FROM [dbo].[COMMISSION_RESULT_NAME1]
	 UNION
	 SELECT * FROM [dbo].[COMMISSION_RESULT_NAME2]
	 UNION
	 SELECT * FROM [dbo].[COMMISSION_RESULT_NAME3]
	 UNION
	 SELECT * FROM [dbo].[COMMISSION_RESULT_NAME4]
	  UNION
	 SELECT * FROM [dbo].[COMMISSION_RESULT_NAME5]
	  UNION
	 SELECT * FROM [dbo].[COMMISSION_RESULT_NAME6]
	 UNION
        select x FROM [dbo].[STATEMENT_DETAILS_ADD]
*/
select *
from
    dbo.COMMISSION_RESULT;

CREATE PROCEDURE [dbo].[SP_IMPORT_FILE_SENT_SSIS]
@Month nvarchar(30),
@Year int
AS

BEGIN
    
    -- SET NOCOUNT ON added to prevent extra result sets from
    
    -- interfering with SELECT statements.
    
    SET NOCOUNT ON;
    --EXEC msdb..sp_start_job @job_name='Broker_Commission'
    DELETE
    FROM
        [dbo].[STATEMENT_HEADER]
    WHERE
          [MONTH] = @Month
      AND [YEAR] = @Year
    
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
      , R.[BROKER_ID]
      , R.[BROKER_NAME]
      , 0
      , R.[TOTAL]
      , GETDATE( )
    FROM
        [dbo].[COMMISSION_SUMMARY] AS R
    WHERE
          R.[BROKER_NAME] IS NOT NULL
      AND R.BROKER_ID IS NOT NULL

END

go

/*B  UI: user clicks Upload Results*/

