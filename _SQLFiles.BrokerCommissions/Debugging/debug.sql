use Broker_Commission;
go

select *
from
    dbo.BROKER_MASTER t
where
    t.BROKER_NAME like '%ADV%'
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
    CLIENT_NAME like '%AIMS%'
order by
    STATEMENT_DETAILS.OPEN_BALANCE desc;

select *
from
    dbo.Import_OCT
where
    name like '%aims%';

