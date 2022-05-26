use Broker_Commission;

create view vw_statement_details_archive_and_paid
as
    select
        da.*
      , si.OPEN_BALANCE PaidOpenBalance
      , si.COMMISSION_PAID PaidCommission
      , si.DATE_PAID PaidDate
      , si.BROKER_ID PaidBrokerId
      , si.month PaidMonth
      , si.year PaidYear
    from
        dbo.STATEMENT_DETAILS_ARCHIVE da
            left join SENT_INVOICE si on da.INVOICE_NUM = si.INVOICE_NUM

select *
from
    vw_statement_details_archive_and_paid
where
        HEADER_ID = ? and
        line_payment_status = 'paid'
  or    (line_payment_status = 'already_paid' and PaidMonth = month and PaidYear = year);

ALTER VIEW [dbo].[DASH_BOARD]
    AS
        (
            
            SELECT
                BM.ID
              , BM.BROKER_NAME
              , BM.PAYLOCITY_ID
              , BM.PREMIUM
              , BM.EMAIL
              , BM.SECONDARY_EMAIL
              , BM.STATUS
              , BM.PREMIUM_TH
              , BM.NOTES
              , BM.BROKER_STATUS
              , BM.BROKER_NAME_ID
              , BM.BROKER_NAME_1
              , BM.BROKER_NAME_2
              , BM.BROKER_NAME_3
              , BM.BROKER_NAME_4
              , BM.BROKER_NAME_5
              , BM.BROKER_NAME_6
              , BM.BROKER_NAME_ID_FORMATTED
              , BM.BROKER_NAME_FORMATTED
              , BM.BROKER_NAME_1_FORMATTED
              , BM.BROKER_NAME_2_FORMATTED
              , BM.BROKER_NAME_3_FORMATTED
              , BM.BROKER_NAME_4_FORMATTED
              , BM.BROKER_NAME_5_FORMATTED
              , BM.BROKER_NAME_6_FORMATTED
              , BM.created_at
              , BM.created_by
              , dbo.get_broker_commission_paid_amount( ID , dbo.get_current_statement_month( ) ,
                                                       dbo.get_current_statement_year( ) ) +
                dbo.get_broker_commission_pending_amount( ID , dbo.get_current_statement_month( ) ,
                                                          dbo.get_current_statement_year( ) )
                    TOTAL_AMOUNT
            
            FROM
                [dbo].[BROKER_MASTER] AS BM
        )
go

