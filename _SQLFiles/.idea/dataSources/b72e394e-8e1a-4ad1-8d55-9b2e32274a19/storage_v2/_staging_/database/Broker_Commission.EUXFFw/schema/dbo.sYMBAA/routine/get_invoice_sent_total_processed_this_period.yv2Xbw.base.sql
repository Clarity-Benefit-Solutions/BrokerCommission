create 

    function get_invoice_sent_total_processed_this_period(
                                                    @invNum nvarchar(500),
                                                    @month varchar(50),
                                                    @year int ) returns numeric as
begin
    declare @amount numeric;
    --      total both [COMMISSION_PAID] + [OPEN_BALANCE] as that would be waht we sent out for the poeriod in question
    select
        @amount = sum( [COMMISSION_PAID] + [OPEN_BALANCE])
    from
        [dbo].[SENT_INVOICE]
    where
          INVOICE_NUM_FORMATTED = rtrim( ltrim( upper( @invNum ) ) )
      and month = @month
      and year = @year;
    
    return isnull( @amount , 0 );
end
go

