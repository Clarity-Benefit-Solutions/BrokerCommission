use Broker_Commission;
go

/*
delete from sent_invoice;
*/
/*find invoices aggregated to more than one broker*/
select *
from
    vw_incorrect_inv_nos1
order by
    vw_incorrect_inv_nos1.INVOICE_NUM;

/* find incorrectly mapped brokers*/
select distinct
    id
  , BROKER_NAME
  , QB_BROKER_NAME
  , QB_FEE
  , BROKER_NAME_1
  , BROKER_NAME_2
  , BROKER_NAME_3
  , BROKER_NAME_4
  , BROKER_NAME_5
  , BROKER_NAME_6
  , CLIENT_NAME
  , FEE_MEMO
from
    dbo.BROKER_CLIENT
where
        id in (4,
               74,
               52,
               85,
               30
        )
  and   CLIENT_NAME in (
                           select distinct
                               client_name
                           from
                               dbo.STATEMENT_DETAILS d
                           where
                                   d.INVOICE_NUM in (
                                                        select
                                                            INVOICE_NUM
                                                        from
                                                            vw_incorrect_inv_nos1
                                                    )
                       )
order by
    BROKER_CLIENT.QB_BROKER_NAME;

/**/
select *
from
    dbo.STATEMENT_DETAILS d

/*si*/
select
    INVOICE_NUM
  , BROKER_ID
  , COMMISSION_PAID
from
    dbo.SENT_INVOICE
where
        INVOICE_NUM_FORMATTED in
        (
            /* patterson */
         '201220809', '201221003', '201221954', '201222197', '201222495'
            /* empire */
            , '201224286'
            /* steven kramer */
            , '201222954', '201222955', '201220765', '201220773', '201223359', '201221079', '201225686', '201221952',
         '201222029', '201221995', '201224340', '201224341', '201221917'
            );
/* join*/
select distinct
    CLIENT_NAME
from
    (
        select
            d.INVOICE_NUM
          , d.QB_FEE
          , h.BROKER_NAME
          , h.BROKER_ID
            --   , d.BROKER_ID
            --   , i.BROKER_ID
          , i.COMMISSION_PAID
          , CLIENT_NAME
          , dbo.get_invoice_sent_total_paid( d.INVOICE_NUM ) already_paid
          , d.TOTAL_PRICE
          , d.line_payment_status
            --   , i.INVOICE_NUM
            --   , d.*
        from
            dbo.STATEMENT_DETAILS d
                left join STATEMENT_HEADER h on d.HEADER_ID = h.HEADER_ID
                left join SENT_INVOICE i on h.BROKER_ID = i.BROKER_ID
        where
                d.INVOICE_NUM in (
                                     select
                                         INVOICE_NUM
                                     from
                                         vw_incorrect_inv_nos1
                                 )
    ) t;
order by d.INVOICE_NUM
  , d.BROKER_NAME;

/* find recs from import*/
select
    d.Date
  , d.Num
  , d.Name
  , d.Memo
  , d.Agent
  , d.ID
  , d.Type
  , d.Qty
  , d.[Sales Price]
  , d.Amount
  , d.[Open Balance]
  , d.NUM_FORMATTED
  , d.memo_FORMATTED
  , d.Agent_FORMATTED
  , d.Name_FORMATTED
  , d.created_at
  , d.statement_month
  , d.statement_year
  , d.is_deleted
from
    dbo.Import_OCT d
where
        d.NUM_FORMATTED in (
                               select
                                   INVOICE_NUM
                               from
                                   vw_incorrect_inv_nos1
                           )
order by
    d.Num
  , d.Agent
  , Name;

-- exec SP_IMPORT_FILE_SENT_SSIS  'MARCH', 2022;
go
select * from dbo.BROKER_MASTER where BROKER_NAME like '%DEL%';
go
Select * from dbo.STATEMENT_DETAILS where BROKER_ID = 26;
go
Select line_payment_status, sum(TOTAL_PRICE), sum(OPEN_BALANCE) from dbo.STATEMENT_DETAILS where BROKER_ID = 26
group by line_payment_status;
;
delete from dbo.SENT_INVOICE where month ='MARCH' and year = 2022;
