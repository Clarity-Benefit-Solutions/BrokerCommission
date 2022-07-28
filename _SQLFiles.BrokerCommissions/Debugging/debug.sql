use Broker_Commission;
go

select *
from
    dbo.Broker_Master t
where
    t.BROKER_NAME like '%ASC%'
go

select *
from
    dbo.Sent_Invoice
where
    month = 'MARCH';

select *
from
    dbo.Import
where
    name like '%CPS METALS INC%';

-- delete from dbo.SENT_INVOICE where month = 'MARCH';

select *
from
    dbo.Statement_Details
where
    BROKER_NAME like '%STEVEN%'
order by
    Statement_Details.OPEN_BALANCE desc;
select *
from
    dbo.Statement_Details
where
      BROKER_ID = 2
--   and CLIENT_NAME like 'CMS%'
order by
    Statement_Details.CLIENT_NAME
  , Statement_Details.QB_FEE asc

-- delete from dbo.STATEMENT_DETAILS where BROKER_ID =2 and DETAIL_ID <> 169642;
select *
from
    dbo.Statement_Details_Add
where
    BROKER_ID = 2
select *
from
    dbo.vw_STATEMENT_DETAILS_ADD
where
    BROKER_ID = 2

select *
from
    dbo.Import
where
    name like '%aims%';
go

select *
from
    vw_statement_design_view
where
    BROKER_ID = 2
order by
    vw_statement_design_view.CLIENT_NAME
  , vw_statement_design_view.FEE_MEMO;

select *
from
    dbo.Import
where
      Name like 'CMS FACILITIES MGT SERVICES LLC'
  and memo_FORMATTED like 'HRA';

select * from
        [dbo].[COMMISSION_RESULT] AS RT
