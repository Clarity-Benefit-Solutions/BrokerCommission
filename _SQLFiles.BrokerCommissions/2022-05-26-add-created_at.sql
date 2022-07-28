use Broker_Commission;
go

alter table Broker_Commission
    add created_at datetime2 default getdate( ) not null;

alter table Broker_Commission
    add created_by nvarchar(200) default user_name( );


alter table Broker_Group
    add created_at datetime2 default getdate( ) not null;

alter table Broker_Group
    add created_by nvarchar(200) default user_name( );



alter table Broker_Master
    add created_at datetime2 default getdate( ) not null;

alter table Broker_Master
    add created_by nvarchar(200) default user_name( );

alter table Broker_Master_
    add created_at datetime2 default getdate( ) not null;

alter table Broker_Master_
    add created_by nvarchar(200) default user_name( );


alter table Client
    add created_at datetime2 default getdate( ) not null;

alter table Client
    add created_by nvarchar(200) default user_name( );

alter table Client_
    add created_at datetime2 default getdate( ) not null;

alter table Client_
    add created_by nvarchar(200) default user_name( );


alter table Detail_Input
    add created_at datetime2 default getdate( ) not null;

alter table Detail_Input
    add created_by nvarchar(200) default user_name( );


alter table Error_Msg
    add created_at datetime2 default getdate( ) not null;

alter table Error_Msg
    add created_by nvarchar(200) default user_name( );


alter table Fee_Memo
    add created_at datetime2 default getdate( ) not null;

alter table Fee_Memo
    add created_by nvarchar(200) default user_name( );


alter table Import_Archive
    add created_by nvarchar(200) default user_name( );


alter table Import
    add created_by nvarchar(200) default user_name( );


alter table Sent_Invoice
    add created_at datetime2 default getdate( ) not null;

alter table Sent_Invoice
    add created_by nvarchar(200) default user_name( );


alter table Statement_Details
    add created_at datetime2 default getdate( ) not null;

alter table Statement_Details
    add created_by nvarchar(200) default user_name( );


alter table Statement_Details_Add
    add created_at datetime2 default getdate( ) not null;

alter table Statement_Details_Add
    add created_by nvarchar(200) default user_name( );


alter table Statement_Details_Archive
    add created_at datetime2 default getdate( ) not null;

alter table Statement_Details_Archive
    add created_by nvarchar(200) default user_name( );


alter table Statement_Header
    add created_at datetime2 default getdate( ) not null;

alter table Statement_Header
    add created_by nvarchar(200) default user_name( );


alter table Statement_Header_Archive
    add created_at datetime2 default getdate( ) not null;

alter table Statement_Header_Archive
    alter created_by nvarchar(200) default user_name( ) cascade;

/**/
alter table dbo.Statement_Details alter column  QUANTITY numeric(18,2);
alter table dbo.Statement_Details_Add alter column  QUANTITY numeric(18,2);
alter table dbo.Statement_Details_Archive alter column  QUANTITY numeric(18,2);
alter table dbo.Import alter column  qty numeric(18,2);
alter table dbo.Import_Archive alter column  qty numeric(18,2);

select * from COMMISSION_RESULT
