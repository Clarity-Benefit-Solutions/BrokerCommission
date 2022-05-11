use Broker_Commission;
go

create function get_broker_commission_amount( @broker_id int ) returns numeric as
begin
    declare @amount numeric;
    
    select
        @amount = sum( [COMMISSION AMOUNT] )
    from
        dbo.[COMMISSION_RESULT]
    where
        BROKER_ID = @broker_id;
    
    return isnull( @amount , 0 );
end

--  sumeet: modified to use indexed formatted columns
go
alter VIEW [dbo].[COMMISSION_SUMMARY]
    AS
        SELECT
            --DISTINCT
            RT.[BROKER_ID]
          , RT.[BROKER_NAME]
          , RT.PAYLOCITY_ID
          , dbo.get_broker_commission_amount( RT.BROKER_ID )
                TOTAL
        FROM
            [dbo].[COMMISSION_RESULT] AS RT
        GROUP BY
            RT.[BROKER_ID]
          , RT.[BROKER_NAME]
          , RT.PAYLOCITY_ID

go

