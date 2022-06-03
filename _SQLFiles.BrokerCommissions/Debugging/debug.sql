use Broker_Commission;
go

select *
from
    dbo.BROKER_MASTER t
where
    t.BROKER_NAME like '%ASC%'
go

select *
from
    dbo.SENT_INVOICE
where
    month = 'MARCH';

select *
from
    dbo.Import_OCT
where
    name like '%CPS METALS INC%';

-- delete from dbo.SENT_INVOICE where month = 'MARCH';

select *
from
    dbo.STATEMENT_DETAILS
where
    BROKER_NAME like '%STEVEN%'
order by
    STATEMENT_DETAILS.OPEN_BALANCE desc;
select *
from
    dbo.STATEMENT_DETAILS
where
      BROKER_ID = 2
  and CLIENT_NAME like 'CMS%'
order by
    STATEMENT_DETAILS.CLIENT_NAME
  , STATEMENT_DETAILS.QB_FEE asc

-- delete from dbo.STATEMENT_DETAILS where BROKER_ID =2 and DETAIL_ID <> 169642;
select *
from
    dbo.STATEMENT_DETAILS_ADD
where
    BROKER_ID = 2

select *
from
    dbo.Import_OCT
where
    name like '%aims%';

create view vw_statement_design_view
as
    select
        DETAIL_ID
      , HEADER_ID
      , INVOICE_DATE
      , INVOICE_NUM
      , QB_CLIENT_NAME
      , CLIENT_NAME
      , BROKER_ID
      , BROKER_NAME
      , QB_FEE
      , FEE_MEMO
      , QUANTITY
      , COMMISSION_RATE
      , UNIT
      , STATUS
      , SALES_PRICE
      , TOTAL_PRICE
      , START_DATE
      , BROKER_STATUS
      , OPEN_BALANCE
      , month
      , year
      , line_payment_status
      , created_at
      , created_by
    from
        dbo.STATEMENT_DETAILS
    union all
    select
        DETAIL_ID
      , HEADER_ID
      , null
      , null
      , QB_CLIENT_NAME
      , CLIENT_NAME
      , BROKER_ID
      , BROKER_NAME
      , QB_FEE
      , FEE_MEMO
      , QUANTITY
      , COMMISSION_RATE
      , UNIT
      , null STATUS
      , SALES_PRICE
      , TOTAL_PRICE
      , START_DATE
      , BROKER_STATUS
      , 0
      , null month
      , null year
      , null line_payment_status
      , created_at
      , created_by
    
    from
        dbo.STATEMENT_DETAILS_ADD

select * from vw_statement_design_view where BROKER_ID =2 order by  vw_statement_design_view.CLIENT_NAME, vw_statement_design_view.FEE_MEMO;


select * from dbo.Import_OCT where Name like 'CMS FACILITIES MGT SERVICES LLC' and memo_FORMATTED like 'HRA';
