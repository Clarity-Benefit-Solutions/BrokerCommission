use Broker_Commission;
Go;

/*1. import new file*/
exec dbo.SP_FILE_IMPORT_SSIS;
go
/*2. run  post imnport proc that generates statement headers and details */
exec [dbo].[SP_IMPORT_FILE_SENT_SSIS] 'MARCH' , 2022;
go
/* 3. Import_OCT*/
select *
from
    dbo.Import_OCT;
go
/* 3. Import_Archive*/
select *
from
    dbo.Import_Archive
where
      statement_month = 'MARCH'
  and statement_year = 2022;
go
go

/* 3. statement header*/
select *
from
    dbo.STATEMENT_HEADER;
/* 3. statement header archive */
select *
from
    dbo.STATEMENT_HEADER_ARCHIVE
where
      month = 'MARCH'
  and year = 2022;
go

/* 3. statement details*/
select *
from
    dbo.STATEMENT_DETAILS;

/* 3. statement details archive */
select *
from
    dbo.STATEMENT_DETAILS_ARCHIVE
where
      month = 'MARCH'
  and year = 2022;
go

select * from dbo.VW_STATEMENT;
