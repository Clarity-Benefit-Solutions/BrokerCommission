create or alter
 function get_invoice_sent_total_paid( @invNum nvarchar(500) ) returns numeric(18,2) as
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

