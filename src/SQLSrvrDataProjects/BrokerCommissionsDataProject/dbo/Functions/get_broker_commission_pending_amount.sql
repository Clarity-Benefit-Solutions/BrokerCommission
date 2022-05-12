create   function get_broker_commission_pending_amount(
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