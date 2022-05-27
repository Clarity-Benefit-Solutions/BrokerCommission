use Broker_Commission;
go
/* ensure we return money as by mistake retuning numeric leads to decimal amounts being retunred as zero*/
create or
alter
    function get_broker_commission_already_paid_amount(
                                                      @broker_id int,
                                                      @month varchar(50),
                                                      @year int ) returns money as
begin
    declare @amount money;
    
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

create or
alter
    function get_broker_commission_paid_amount(
                                              @broker_id int,
                                              @month varchar(50),
                                              @year int ) returns money as
begin
    declare @amount money;
    
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
alter function get_broker_commission_pending_amount(
                                                   @broker_id int,
                                                   @month varchar(50),
                                                   @year int ) returns money as
begin
    declare @amount money;
    
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

create or
alter
    function get_current_statement_month( ) returns varchar(50) as
begin
    declare @value varchar(50);
    
    select top 1
        @value = MONTH
    from
        dbo.STATEMENT_HEADER;
    
    return isnull( @value , 0 );
end
go

create or
alter
    function get_current_statement_year( ) returns int as
begin
    declare @value int;
    
    select top 1
        @value = year
    from
        dbo.STATEMENT_HEADER;
    
    return isnull( @value , 0 );
end
go

create or
alter
    function get_invoice_sent_total_open_balance( @invNum nvarchar(500) ) returns money as
begin
    declare @amount money;
    
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
alter
    function get_invoice_sent_total_paid( @invNum nvarchar(500) ) returns money as
begin
    declare @amount money;
    
    select
        @amount = sum( [COMMISSION_PAID] )
    from
        [dbo].[SENT_INVOICE]
    where
        INVOICE_NUM_FORMATTED = rtrim( ltrim( upper( @invNum ) ) );
    
    return isnull( @amount , 0 );
end
go

create or
alter
    function get_invoice_sent_total_processed_this_period(
                                                         @invNum nvarchar(500),
                                                         @month varchar(50),
                                                         @year int ) returns money as
begin
    declare @amount money;
    --      total both [COMMISSION_PAID] + [OPEN_BALANCE] as that would be waht we sent out for the poeriod in question
    select
        @amount = sum( [COMMISSION_PAID] + [OPEN_BALANCE] )
    from
        [dbo].[SENT_INVOICE]
    where
          INVOICE_NUM_FORMATTED = rtrim( ltrim( upper( @invNum ) ) )
      and month = @month
      and year = @year;
    
    return isnull( @amount , 0 );
end
go

create or
alter
    function get_total_processed_this_period(
    @header_id int ) returns money as
begin
    declare @amount money;
    --      total both [COMMISSION_PAID] + [OPEN_BALANCE] as that would be waht we sent out for the poeriod in question
    select
            @amount = sum( dbo.get_invoice_sent_total_processed_this_period( INVOICE_NUM , month , year ) )
    from
        [dbo].[STATEMENT_DETAILS]
    where
        HEADER_ID = @header_id;
    
    return isnull( @amount , 0 );
end
go

create or
alter
    function get_total_processed_this_period_NOTGOOD(
    @header_id int ) returns money as
begin
    declare @amount money;
    --      total both [COMMISSION_PAID] + [OPEN_BALANCE] as that would be waht we sent out for the poeriod in question
    select
        @amount = sum( TOTAL_PRICE )
    from
        [dbo].[STATEMENT_DETAILS]
    where
          HEADER_ID = @header_id
      and line_payment_status = 'paid';
    
    return isnull( @amount , 0 );
end
go

