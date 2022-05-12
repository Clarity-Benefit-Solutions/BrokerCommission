use Broker_Commission;
Go;

/* clear all sent invoices*/
truncate table dbo.SENT_INVOICE;

/*1. import new file*/
exec dbo.SP_FILE_IMPORT_SSIS;
go

/*2. run  post imnport proc that generates statement headers and details for month 1*/
exec [dbo].[SP_IMPORT_FILE_SENT_SSIS] 'FEBRUARY' , 2022;
go

/* 3.how much would we pay the broker */
select *
from
    dbo.STATEMENT_HEADER
where
    BROKER_ID = 26
order by
    BROKER_NAME;

/* insert jan paid invoices to sent_invoices for month 1  */
insert into dbo.SENT_INVOICE (
                             INVOICE_NUM,
                             OPEN_BALANCE,
                             STATEMENT_TOTAL
)
select
    INVOICE_NUM
  , OPEN_BALANCE
  , TOTAL_PRICE
from
    dbo.STATEMENT_DETAILS
where
      INVOICE_DATE = '2022-02-01'
  and line_payment_status = 'paid';


go
exec [dbo].[SP_IMPORT_FILE_SENT_SSIS] 'MARCH' , 2022;
go

/* 3.how much would we pay the broker */
select *
from
    dbo.STATEMENT_HEADER
where
    BROKER_ID = 26
order by
    BROKER_NAME;

/* insert jan paid invoices to sent_invoices for month 1  */
insert into dbo.SENT_INVOICE (
                             INVOICE_NUM,
                             OPEN_BALANCE,
                             STATEMENT_TOTAL
)
select
    INVOICE_NUM
  , OPEN_BALANCE
  , TOTAL_PRICE
from
    dbo.STATEMENT_DETAILS
where
      INVOICE_DATE = '2022-03-01'
  and line_payment_status = 'paid';


go
exec [dbo].[SP_IMPORT_FILE_SENT_SSIS] 'APRIL' , 2022;
go

/* 3.how much would we pay the broker */
select *
from
    dbo.STATEMENT_HEADER
where
    BROKER_ID = 26
order by
    BROKER_NAME;


/* insert jan paid invoices to sent_invoices for month 1  */
insert into dbo.SENT_INVOICE (
                             INVOICE_NUM,
                             OPEN_BALANCE,
                             STATEMENT_TOTAL
)
select
    INVOICE_NUM
  , OPEN_BALANCE
  , TOTAL_PRICE
from
    dbo.STATEMENT_DETAILS
Project Mx, Broker Commissions,


where
      INVOICE_DATE = '2022-04-01'
  and line_payment_status = 'paid';


go
exec [dbo].[SP_IMPORT_FILE_SENT_SSIS] 'MAY' , 2022;
go

/* 3.how much would we pay the broker */
select *
from
    dbo.STATEMENT_HEADER
where
    BROKER_ID = 26
order by
    BROKER_NAME;
