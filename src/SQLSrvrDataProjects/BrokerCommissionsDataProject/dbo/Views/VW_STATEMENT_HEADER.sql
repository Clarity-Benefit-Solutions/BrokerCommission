create   view VW_STATEMENT_HEADER
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
        STATEMENT_HEADER