use Broker_Commission;
go

select *
from
    dbo.SENT_INVOICE;

alter table dbo.SENT_INVOICE
    add month varchar(50) not null;
alter table dbo.SENT_INVOICE
    add year int not null;
alter table dbo.SENT_INVOICE
    add DATE_PAID datetime not null;
alter table SENT_INVOICE
    drop column DATE_ENTER
go



alter table SENT_INVOICE
    alter column INVOICE_NUM varchar(500) not null
go

alter table SENT_INVOICE
    alter column OPEN_BALANCE numeric(18, 2) not null
go

-- column does not support rename

-- don't know how to alter nullability of SENT_INVOICE.INVOICE_NUM_FORMATTED

exec sp_rename 'SENT_INVOICE.STATEMENT_TOTAL' , COMMISSION_PAID , 'COLUMN'
go

alter table SENT_INVOICE
    alter column COMMISSION_PAID numeric(18, 2) not null
go

create unique index INVOICE_NUM_FORMATTED
    on SENT_INVOICE (INVOICE_NUM_FORMATTED)
go



alter table dbo.[SENT_INVOICE]
    add INVOICE_NUM_FORMATTED
        as
            LTRIM(
                    RTRIM(
                            UPPER( INVOICE_NUM )
                        )
                ) PERSISTED;
Go

CREATE or
alter procedure dbo.SP_INSERT_SENT_INVOICE(
                                       @INVOICE_NUM varchar(500),
                                       @DATE_PAID datetime,
                                       @OPEN_BALANCE numeric(18, 2),
                                       @COMMISSION_PAID numeric(18, 2),
                                       @month varchar(50),
                                       @year int ) as
begin
    
    declare @id int;
    declare @msg varchar(max);
    
    SET NOCOUNT ON
    /* if fileLogId = 0 or processingTask = 'New', we will insert into main and detail tables
       else we will insert only into the detailed table
    */
    
    if isnull( @INVOICE_NUM , '' ) = ''
        begin
            THROW 51000, 'Invoice_Num Cannot be Empty', 1;
        end
    
    set @INVOICE_NUM = rtrim( ltrim( upper( @INVOICE_NUM ) ) );
    select top 1
        @id = id
    from
        dbo.SENT_INVOICE
    where
        INVOICE_NUM_FORMATTED = @INVOICE_NUM;
    
    if isnull( @id , 0 ) != 0
        begin
            set @msg = concat( 'Invoice_Num ' , @INVOICE_NUM , ' is already inserted in the table and marked as paid' );
            THROW 51000, @msg, 1;
        end
    
    insert into dbo.SENT_INVOICE(
                                INVOICE_NUM,
                                OPEN_BALANCE,
                                COMMISSION_PAID,
                                month,
                                year,
                                DATE_PAID
    )
    values (
           @INVOICE_NUM,
           @OPEN_BALANCE,
           @COMMISSION_PAID,
           @month,
           @year,
           @DATE_PAID
           );
    
    set @Id = SCOPE_IDENTITY( );
    /* return the header PK */
    select
        @id;
end;
go

exec SP_INSERT_SENT_INVOICE '1', '2022-05-13',1, 1, 'JANUARY', 2022;
