use Broker_Commission;
go
alter table Broker_Commission
    alter column created_at datetime2 not null
go

alter table Broker_Commission
    add constraint DF__BROKER_MASTER___created__3BFFE745 default getdate( ) for created_at
go

alter table Broker_Commission
    add constraint DF__BROKER_MASTER___created__3CF40B7E default user_name( ) for created_by
go
/**/

alter table Broker_Group
    alter column created_at datetime2 not null
go

alter table Broker_Group
    add constraint created_at_bg default getdate( ) for created_at
go

alter table Broker_Group
    add constraint created_by_bg default user_name( ) for created_by
go

/**/
alter table Broker_Master
    alter column created_at datetime2 not null
go

alter table Broker_Master
    add constraint created_at_BROKER_MASTER default getdate( ) for created_at
go

alter table Broker_Master
    add constraint created_by_BROKER_MASTER default user_name( ) for created_by
go

/**/
alter table Broker_Master_
    alter column created_at datetime2 not null
go

alter table Broker_Master_
    add constraint DF__BROKER_MASTER__created__3BFFE745 default getdate( ) for created_at
go

alter table Broker_Master_
    add constraint DF__BROKER_MASTER__created__3CF40B7E default user_name( ) for created_by
go

/**/
alter table Client
    alter column created_at datetime2 not null
go

alter table Client
    add constraint CLIENT_created_at default getdate( ) for created_at
go

alter table Client
    add constraint CLIENT_created_by default user_name( ) for created_by
go


alter table Client_
    alter column created_at datetime2 not null
go

alter table Client_
    add constraint CLIENT__created_at default getdate( ) for created_at
go

alter table Client_
    add constraint CLIENT__created_by default user_name( ) for created_by
go



alter table Fee_Memo
    alter column created_at datetime2 not null
go

alter table Fee_Memo
    add constraint created_at_FEE_MEMO default getdate( ) for created_at
go

alter table Fee_Memo
    add constraint created_by_FEE_MEMO default user_name( ) for created_by
go
/**/

alter table Import_Archive
    alter column created_at datetime2 not null
go

alter table Import_Archive
    add constraint created_at_Import_Archive default getdate( ) for created_at
go

alter table Import_Archive
    add constraint created_by_Import_Archive default user_name( ) for created_by
go
/**/
alter table Import
    alter column created_at datetime2 not null
go

alter table Import
    add constraint created_at_Import_oct default getdate( ) for created_at
go

alter table Import
    add constraint created_by_Import_oct default user_name( ) for created_by
go
/**/
alter table Sent_Invoice
    alter column created_at datetime2 not null
go

alter table Sent_Invoice
    add constraint created_at_SENT_INVOICE default getdate( ) for created_at
go

alter table Sent_Invoice
    add constraint created_by_SENT_INVOICE default user_name( ) for created_by
go
/**/
alter table Statement_Details
    alter column created_at datetime2 not null
go

alter table Statement_Details
    add constraint created_at_STATEMENT_DETAILS default getdate( ) for created_at
go

alter table Statement_Details
    add constraint created_by_STATEMENT_DETAILS default user_name( ) for created_by
go
alter table Statement_Details_Add
    alter column created_at datetime2 not null
go

alter table Statement_Details_Add
    add constraint created_at_STATEMENT_details_add default getdate( ) for created_at
go

alter table Statement_Details_Add
    add constraint created_by_STATEMENT_details_add default user_name( ) for created_by
go
/**/

alter table Statement_Details_Archive
    alter column created_at datetime2 not null
go

alter table Statement_Details_Archive
    add constraint created_at_STATEMENT_details_archive default getdate( ) for created_at
go

alter table Statement_Details_Archive
    add constraint created_by_STATEMENT_details_archive default user_name( ) for created_by
go
/**/
alter table Statement_Header
    alter column created_at datetime2 not null
go

alter table Statement_Header
    add constraint created_at_STATEMENT_HEADER default getdate( ) for created_at
go

alter table Statement_Header
    add constraint created_by_STATEMENT_HEADER default user_name( ) for created_by
go
/**/

alter table Statement_Header_Archive
    alter column created_at datetime2 not null
go

alter table Statement_Header_Archive
    add constraint created_at_STATEMENT_HEADER_ARCHIVE default getdate( ) for created_at
go

alter table Statement_Header_Archive
    add constraint created_by_STATEMENT_HEADER_ARCHIVE default user_name( ) for created_by
go
/**/
