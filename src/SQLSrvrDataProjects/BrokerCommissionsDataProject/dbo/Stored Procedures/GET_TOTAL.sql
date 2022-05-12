CREATE PROCEDURE [dbo].[GET_TOTAL]( @bid AS int )
    -- Add the parameters for the stored procedure here

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
    
    -- Insert statements for procedure here
    SELECT
        TOTAL TOTAL_COMMISSION
    FROM
        [dbo].[COMMISSION_SUMMARY]
    WHERE
        BROKER_ID = @bid

END