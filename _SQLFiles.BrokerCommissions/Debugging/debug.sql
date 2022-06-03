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
go
create or alter view vw_statement_design_view
as
    select
        min( t.DETAIL_ID ) DETAIL_ID
      , t.HEADER_ID
      , t.INVOICE_DATE
      , t.INVOICE_NUM
      , t.QB_CLIENT_NAME
      , min( t.CLIENT_NAME ) CLIENT_NAME
      , t.BROKER_ID
      , min( t.BROKER_NAME ) BROKER_NAME
      , min( t.QB_FEE ) QB_FEE
      , t.FEE_MEMO
      , min( t.QUANTITY ) QUANTITY
      , min( t.COMMISSION_RATE ) COMMISSION_RATE
      , min( t.UNIT ) UNIT
      , min( t.STATUS ) STATUS
      , min( t.SALES_PRICE ) SALES_PRICE
      , t.TOTAL_PRICE
      , min( t.START_DATE ) START_DATE
      , min( t.BROKER_STATUS ) BROKER_STATUS
      , min( t.OPEN_BALANCE ) OPEN_BALANCE
      , min( t.month ) month
      , min( t.year ) year
      , min( t.line_payment_status ) line_payment_status
      , min( t.created_at ) created_at
      , min( t.created_by ) created_by
    from
        (
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
              , 'manually_added' line_payment_status
              , created_at
              , created_by
            
            from
                dbo.STATEMENT_DETAILS_ADD
        ) t
    group by
        
        t.QB_CLIENT_NAME
      , t.INVOICE_DATE
      , t.INVOICE_NUM
      , t.HEADER_ID
      , t.BROKER_ID
      , t.FEE_MEMO
      , t.TOTAL_PRICE
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
    dbo.Import_OCT
where
      Name like 'CMS FACILITIES MGT SERVICES LLC'
  and memo_FORMATTED like 'HRA';
