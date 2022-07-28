use Broker_Commission;
go

/*

1) always use _archive in statements
2) add fields to statement_header
    generated_at
    emailed_at
    status
        'NEW'
        'GENERATED'
        'EMAILED'
        'HELDBACK'
    last_generate_error
    last_email_error
3) add new fields to broker
    hold_statements_from
    hold_statements_to
    hold_for_current_period
4) sent_invoices : mapping ? add broker_id to PK
5) new tables for calculating status
*/


*/
