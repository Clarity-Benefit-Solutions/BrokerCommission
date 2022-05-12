﻿create 
 function get_invoice_sent_total_open_balance( @invNum nvarchar(500) ) returns numeric as
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