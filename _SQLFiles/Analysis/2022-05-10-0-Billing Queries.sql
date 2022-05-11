use Broker_Commission;

go

/*
 1	check if memo is commissionable,
2	if open is <=0
3	calculate based on amount or qty
4	display
	per client per memo, qty, pepm, billed, commission
	
	2 divs
    if last statement had an open balance(so if commission was pending), then show that line on this month
	if pending, show  with date = inv date
	else show due

 */

/*BROKER_MASTER*/
select *
from
    dbo.BROKER_MASTER
where
    ID = 26;
/*
BROKER_NAME_ID_FORMATTED	BROKER_NAME_FORMATTED	BROKER_NAME_1_FORMATTED	BROKER_NAME_2_FORMATTED	BROKER_NAME_3_FORMATTED	BROKER_NAME_4_FORMATTED	BROKER_NAME_5_FORMATTED
DELUCA	DELUCA PLANNING	DELUCA PLANNING	DELUCA PLANNING	TONY DELUCA	DELUCA PLANNING	DELUCA PLANNING

*/

/* 1. check count of rows in OCT match excel file filtered by agent name */
select *
from
    dbo.Import_OCT
where
    agent like '%DEL%'
order by
    name
  , Import_OCT.Memo;

select
    ID, BROKER_NAME, CLIENT_NAME, date,  MEMO, Qty, [Sales Price], Amount, [Open Balance], COMMISSION_RATE, UNIT, [COMMISSION AMOUNT],  PAYLOCITY_ID, START_DATE, Num, INVOICE_DATE, CLIENT_ID, Total_Invoice_Sent_Open_Balance
from
    dbo.COMMISSION_RESULT
where
    BROKER_ID = 26
order by COMMISSION_RESULT.BROKER_NAME, COMMISSION_RESULT.CLIENT_NAME, [date], COMMISSION_RESULT.MEMO
;

select *
from
    dbo.COMMISSION_RESULT
where
    BROKER_ID = 26
and Total_Invoice_Sent_Open_Balance <= 0;


select [date], sum([COMMISSION AMOUNT]) CommAmt, sum(Total_Invoice_Sent_Open_Balance) SentAmt
from
    dbo.COMMISSION_RESULT
where
    BROKER_ID = 26
group by [date]
;
select 2730 -2472;



/*name 0  */
select *
from
    dbo.COMMISSION_RESULT_NAME0
where
    BROKER_ID = 26

/*name 1  */
select *
from
    dbo.COMMISSION_RESULT_NAME1
where
    BROKER_ID = 26

/*name 2  */
select *
from
    dbo.COMMISSION_RESULT_NAME2
where
    BROKER_ID = 26;
/*name 3  */
select *
from
    dbo.COMMISSION_RESULT_NAME3
where
    BROKER_ID = 26;
/*name 4  */
select *
from
    dbo.COMMISSION_RESULT_NAME4
where
    BROKER_ID = 26;
/*name 5  */
select *
from
    dbo.COMMISSION_RESULT_NAME5
where
    BROKER_ID = 26;

/*name 6  */
select *
from
    dbo.COMMISSION_RESULT_NAME6
where
    BROKER_ID = 26;


select *
from
    dbo.STATEMENT_HEADER
where
      BROKER_ID = 26
  and month = 'MARCH';

select *
from
    dbo.STATEMENT_DETAILS
where
      BROKER_ID = 26
  and HEADER_ID = 1440;
