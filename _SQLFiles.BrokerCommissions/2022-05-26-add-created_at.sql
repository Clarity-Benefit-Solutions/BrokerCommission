use Broker_Commission;
go

alter table BROKER_COMMISSION
    add created_at datetime2 default getdate( ) not null;

alter table BROKER_COMMISSION
    add created_by nvarchar(200) default user_name( );


alter table BROKER_GROUP
    add created_at datetime2 default getdate( ) not null;

alter table BROKER_GROUP
    add created_by nvarchar(200) default user_name( );



alter table BROKER_MASTER
    add created_at datetime2 default getdate( ) not null;

alter table BROKER_MASTER
    add created_by nvarchar(200) default user_name( );

alter table BROKER_MASTER_
    add created_at datetime2 default getdate( ) not null;

alter table BROKER_MASTER_
    add created_by nvarchar(200) default user_name( );


alter table CLIENT
    add created_at datetime2 default getdate( ) not null;

alter table CLIENT
    add created_by nvarchar(200) default user_name( );

alter table CLIENT_
    add created_at datetime2 default getdate( ) not null;

alter table CLIENT_
    add created_by nvarchar(200) default user_name( );


alter table Detail_Input
    add created_at datetime2 default getdate( ) not null;

alter table Detail_Input
    add created_by nvarchar(200) default user_name( );


alter table Error_Msg
    add created_at datetime2 default getdate( ) not null;

alter table Error_Msg
    add created_by nvarchar(200) default user_name( );


alter table FEE_MEMO
    add created_at datetime2 default getdate( ) not null;

alter table FEE_MEMO
    add created_by nvarchar(200) default user_name( );


alter table Import_Archive
    add created_by nvarchar(200) default user_name( );


alter table Import_OCT
    add created_by nvarchar(200) default user_name( );


alter table SENT_INVOICE
    add created_at datetime2 default getdate( ) not null;

alter table SENT_INVOICE
    add created_by nvarchar(200) default user_name( );


alter table STATEMENT_DETAILS
    add created_at datetime2 default getdate( ) not null;

alter table STATEMENT_DETAILS
    add created_by nvarchar(200) default user_name( );


alter table STATEMENT_DETAILS_ADD
    add created_at datetime2 default getdate( ) not null;

alter table STATEMENT_DETAILS_ADD
    add created_by nvarchar(200) default user_name( );


alter table STATEMENT_DETAILS_ARCHIVE
    add created_at datetime2 default getdate( ) not null;

alter table STATEMENT_DETAILS_ARCHIVE
    add created_by nvarchar(200) default user_name( );


alter table STATEMENT_HEADER
    add created_at datetime2 default getdate( ) not null;

alter table STATEMENT_HEADER
    add created_by nvarchar(200) default user_name( );


alter table STATEMENT_HEADER_ARCHIVE
    add created_at datetime2 default getdate( ) not null;

alter table STATEMENT_HEADER_ARCHIVE
    alter created_by nvarchar(200) default user_name( ) cascade;

/**/
alter table dbo.STATEMENT_DETAILS alter column  QUANTITY numeric(18,2);
alter table dbo.STATEMENT_DETAILS_ADD alter column  QUANTITY numeric(18,2);
alter table dbo.STATEMENT_DETAILS_ARCHIVE alter column  QUANTITY numeric(18,2);
alter table dbo.Import_OCT alter column  qty numeric(18,2);
alter table dbo.Import_Archive alter column  qty numeric(18,2);

select * from COMMISSION_RESULT
