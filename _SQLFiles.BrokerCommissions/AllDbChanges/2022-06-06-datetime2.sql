use Broker_Commission;
go
alter table BROKER_COMMISSION
    alter column created_at datetime2 not null
go

alter table BROKER_COMMISSION
    add constraint DF__BROKER_MASTER___created__3BFFE745 default getdate( ) for created_at
go

alter table BROKER_COMMISSION
    add constraint DF__BROKER_MASTER___created__3CF40B7E default user_name( ) for created_by
go
/**/

alter table BROKER_GROUP
    alter column created_at datetime2 not null
go

alter table BROKER_GROUP
    add constraint created_at_bg default getdate( ) for created_at
go

alter table BROKER_GROUP
    add constraint created_by_bg default user_name( ) for created_by
go

/**/
alter table BROKER_MASTER
    alter column created_at datetime2 not null
go

alter table BROKER_MASTER
    add constraint created_at_BROKER_MASTER default getdate( ) for created_at
go

alter table BROKER_MASTER
    add constraint created_by_BROKER_MASTER default user_name( ) for created_by
go

/**/
alter table BROKER_MASTER_
    alter column created_at datetime2 not null
go

alter table BROKER_MASTER_
    add constraint DF__BROKER_MASTER__created__3BFFE745 default getdate( ) for created_at
go

alter table BROKER_MASTER_
    add constraint DF__BROKER_MASTER__created__3CF40B7E default user_name( ) for created_by
go

/**/
alter table CLIENT
    alter column created_at datetime2 not null
go

alter table CLIENT
    add constraint CLIENT_created_at default getdate( ) for created_at
go

alter table CLIENT
    add constraint CLIENT_created_by default user_name( ) for created_by
go


alter table CLIENT_
    alter column created_at datetime2 not null
go

alter table CLIENT_
    add constraint CLIENT__created_at default getdate( ) for created_at
go

alter table CLIENT_
    add constraint CLIENT__created_by default user_name( ) for created_by
go



alter table FEE_MEMO
    alter column created_at datetime2 not null
go

alter table FEE_MEMO
    add constraint created_at_FEE_MEMO default getdate( ) for created_at
go

alter table FEE_MEMO
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
alter table Import_oct
    alter column created_at datetime2 not null
go

alter table Import_oct
    add constraint created_at_Import_oct default getdate( ) for created_at
go

alter table Import_oct
    add constraint created_by_Import_oct default user_name( ) for created_by
go
/**/
alter table SENT_INVOICE
    alter column created_at datetime2 not null
go

alter table SENT_INVOICE
    add constraint created_at_SENT_INVOICE default getdate( ) for created_at
go

alter table SENT_INVOICE
    add constraint created_by_SENT_INVOICE default user_name( ) for created_by
go
/**/
alter table STATEMENT_DETAILS
    alter column created_at datetime2 not null
go

alter table STATEMENT_DETAILS
    add constraint created_at_STATEMENT_DETAILS default getdate( ) for created_at
go

alter table STATEMENT_DETAILS
    add constraint created_by_STATEMENT_DETAILS default user_name( ) for created_by
go
alter table STATEMENT_details_add
    alter column created_at datetime2 not null
go

alter table STATEMENT_details_add
    add constraint created_at_STATEMENT_details_add default getdate( ) for created_at
go

alter table STATEMENT_details_add
    add constraint created_by_STATEMENT_details_add default user_name( ) for created_by
go
/**/

alter table STATEMENT_details_archive
    alter column created_at datetime2 not null
go

alter table STATEMENT_details_archive
    add constraint created_at_STATEMENT_details_archive default getdate( ) for created_at
go

alter table STATEMENT_details_archive
    add constraint created_by_STATEMENT_details_archive default user_name( ) for created_by
go
/**/
alter table STATEMENT_HEADER
    alter column created_at datetime2 not null
go

alter table STATEMENT_HEADER
    add constraint created_at_STATEMENT_HEADER default getdate( ) for created_at
go

alter table STATEMENT_HEADER
    add constraint created_by_STATEMENT_HEADER default user_name( ) for created_by
go
/**/

alter table STATEMENT_HEADER_ARCHIVE
    alter column created_at datetime2 not null
go

alter table STATEMENT_HEADER_ARCHIVE
    add constraint created_at_STATEMENT_HEADER_ARCHIVE default getdate( ) for created_at
go

alter table STATEMENT_HEADER_ARCHIVE
    add constraint created_by_STATEMENT_HEADER_ARCHIVE default user_name( ) for created_by
go
/**/
