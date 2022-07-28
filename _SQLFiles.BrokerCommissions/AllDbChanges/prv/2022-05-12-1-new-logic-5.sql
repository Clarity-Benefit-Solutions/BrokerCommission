use Broker_Commission;
go

create or
alter function get_current_statement_year( ) returns int as
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
alter function get_current_statement_month( ) returns varchar(50) as
begin
    declare @value varchar(50);
    
    select top 1
        @value = MONTH
    from
        dbo.STATEMENT_HEADER;
    
    return isnull( @value , 0 );
end
go
CREATE or alter VIEW [dbo].[DASH_BOARD]
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

