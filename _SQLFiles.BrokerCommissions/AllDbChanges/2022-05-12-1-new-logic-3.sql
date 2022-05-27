use Broker_Commission;
Go;
drop function if exists get_invoice_sent_total_open_balance;
go
create or
alter function get_invoice_sent_total_open_balance( @invNum nvarchar(500) ) returns numeric as
begin
    declare @amount numeric;
    
    select
        @amount = sum( [OPEN_BALANCE] )
    from
        [dbo].[SENT_INVOICE]
    where
        INVOICE_NUM_FORMATTED = rtrim( ltrim( upper( @invNum ) ) );
    
    return isnull( @amount , 0 );
end
go

create or
alter function get_invoice_sent_total_paid( @invNum nvarchar(500) ) returns numeric as
begin
    declare @amount numeric;
    
    select
        @amount = sum( [COMMISSION_PAID] )
    from
        [dbo].[SENT_INVOICE]
    where
        INVOICE_NUM_FORMATTED = rtrim( ltrim( upper( @invNum ) ) );
    
    return isnull( @amount , 0 );
end
go

drop function if exists get_broker_commission_amount;
go
create or
alter function get_broker_commission_paid_amount(
                                                @broker_id int,
                                                @month varchar(50),
                                                @year int ) returns numeric as
begin
    declare @amount numeric;
    
    select
        @amount = sum( [TOTAL_PRICE] )
    from
        dbo.[STATEMENT_DETAILS]
    where
          BROKER_ID = @broker_id
      and month = @month
      and year = @year
      and line_payment_status = 'paid';
    
    return isnull( @amount , 0 );
end
go

create or
alter function get_broker_commission_already_paid_amount(
                                                @broker_id int,
                                                @month varchar(50),
                                                @year int ) returns numeric as
begin
    declare @amount numeric;
    
    select
        @amount = sum( [TOTAL_PRICE] )
    from
        dbo.[STATEMENT_DETAILS]
    where
          BROKER_ID = @broker_id
      and month = @month
      and year = @year
      and line_payment_status like 'already paid%';
    
    return isnull( @amount , 0 );
end
go


create or alter function get_broker_commission_pending_amount(
                                                    @broker_id int,
                                                    @month varchar(50),
                                                    @year int ) returns numeric as
begin
    declare @amount numeric;
    
    select
        @amount = sum( [TOTAL_PRICE] )
    from
        dbo.[STATEMENT_DETAILS]
    where
          BROKER_ID = @broker_id
      and month = @month
      and year = @year
      and line_payment_status = 'pending';
    
    return isnull( @amount , 0 );
end
go

create or alter view VW_STATEMENT_HEADER
as
    select
        HEADER_ID
      , MONTH
      , YEAR
      , BROKER_ID
      , BROKER_NAME
      , FLAG
      , Change_Date
      , dbo.get_broker_commission_paid_amount( BROKER_ID , MONTH , YEAR ) STATEMENT_TOTAL
      , dbo.get_broker_commission_pending_amount( BROKER_ID , MONTH , YEAR ) STATEMENT_PENDING_TOTAL
    from
        STATEMENT_HEADER;
go
drop view if exists VW_STATEMENT;
go
drop view if exists VW_STATEMENT_PRV;
go

select *
from
    VW_STATEMENT_HEADER;
go
