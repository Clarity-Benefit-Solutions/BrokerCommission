use Broker_Commission
go

-- cmp SUMMARYSUMMARY
select
    'New'
  , sum( [TOTAL] ) TotalAmount
from
    dbo.COMMISSION_SUMMARY
union
select
    'Prv'
  , sum( [TOTAL] ) TotalAmount
from
    dbo.COMMISSION_SUMMARY_PRV;

-- cmp RESULT_NAME0
select
    'New'
  , sum( [COMMISSION AMOUNT] ) TotalAmount
from
    dbo.COMMISSION_RESULT_NAME0
union
select
    'Prv'
  , sum( [COMMISSION AMOUNT] ) TotalAmount
from
    dbo.COMMISSION_RESULT_NAME0_prv;

-- cmp RESULT_NAME1
select
    'New'
  , sum( [COMMISSION AMOUNT] ) TotalAmount
from
    dbo.COMMISSION_RESULT_NAME1
union
select
    'Prv'
  , sum( [COMMISSION AMOUNT] ) TotalAmount
from
    dbo.COMMISSION_RESULT_NAME1_prv;

-- cmp RESULT_NAME2
select
    'New'
  , sum( [COMMISSION AMOUNT] ) TotalAmount
from
    dbo.COMMISSION_RESULT_NAME2
union
select
    'Prv'
  , sum( [COMMISSION AMOUNT] ) TotalAmount
from
    dbo.COMMISSION_RESULT_NAME2_prv;

-- cmp RESULT_NAME3
select
    'New'
  , sum( [COMMISSION AMOUNT] ) TotalAmount
from
    dbo.COMMISSION_RESULT_NAME3
union
select
    'Prv'
  , sum( [COMMISSION AMOUNT] ) TotalAmount
from
    dbo.COMMISSION_RESULT_NAME3_prv;

-- cmp RESULT_NAME4
select
    'New'
  , sum( [COMMISSION AMOUNT] ) TotalAmount
from
    dbo.COMMISSION_RESULT_NAME4
union
select
    'Prv'
  , sum( [COMMISSION AMOUNT] ) TotalAmount
from
    dbo.COMMISSION_RESULT_NAME4_prv;

-- cmp RESULT_NAME5
select
    'New'
  , sum( [COMMISSION AMOUNT] ) TotalAmount
from
    dbo.COMMISSION_RESULT_NAME5
union
select
    'Prv'
  , sum( [COMMISSION AMOUNT] ) TotalAmount
from
    dbo.COMMISSION_RESULT_NAME5_prv;

-- cmp RESULT_NAME6
select
    'New'
  , sum( [COMMISSION AMOUNT] ) TotalAmount
from
    dbo.COMMISSION_RESULT_NAME6
union
select
    'Prv'
  , sum( [COMMISSION AMOUNT] ) TotalAmount
from
    dbo.COMMISSION_RESULT_NAME6_prv;
