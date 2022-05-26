CREATE   VIEW [dbo].[DASH_BOARD]
AS
    (
    
    SELECT
        BM.*
      , dbo.get_broker_commission_paid_amount( ID , dbo.get_current_statement_month( ) ,
                                               dbo.get_current_statement_year( ) ) +
        dbo.get_broker_commission_pending_amount( ID , dbo.get_current_statement_month( ) ,
                                                  dbo.get_current_statement_year( ) )
            TOTAL_AMOUNT
    
    FROM
        [dbo].[BROKER_MASTER] AS BM
        )
go

