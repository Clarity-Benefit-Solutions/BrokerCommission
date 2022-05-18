create view vw_incorrect_inv_nos1
as
    select
        d.INVOICE_NUM
      , count( distinct d.BROKER_ID ) count_broker_id
    from
        dbo.STATEMENT_DETAILS d
    group by
        d.INVOICE_NUM
    having
        count( distinct d.BROKER_ID ) > 1
go

