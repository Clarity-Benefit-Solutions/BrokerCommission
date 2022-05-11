use Broker_Commission;
Go;

/* RENAME TABLE TO PROPER NAME*/

/* ADD COLUMNS FOR WHICH MONTH'S STATEMENT WE JUST IMPIORTED*/

alter table Import_OCT
    add statement_month varchar(50);
alter table Import_OCT
    add statement_year varchar(50);

create index statement_month on dbo.Import_OCT (statement_month);
create index statement_year on dbo.Import_OCT (statement_year);

GO


create table Import_Archive
(
ArchiveID       int identity
    constraint PK_Import_Archive
        primary key,
ID              int not null,
Type            varchar(50),
Date            datetime,
Num             varchar(3000),
Name            varchar(3000),
Memo            varchar(3000),
Agent           varchar(500),
Qty             int,
[Sales Price]   numeric(18, 2),
Amount          numeric(18, 2),
[Open Balance]  numeric(18, 2),
NUM_FORMATTED   varchar(1000),
memo_FORMATTED  varchar(1000),
Agent_FORMATTED varchar(1000),
Name_FORMATTED  varchar(1000),
created_at      datetime,
statement_month varchar(50),
statement_year  varchar(50)
)
go

create index id
    on Import_Archive (id)
go
create index NUM_FORMATTED
    on Import_Archive (NUM_FORMATTED)
go

create index Agent_FORMATTED
    on Import_Archive (Agent_FORMATTED)
go

create index Name_FORMATTED
    on Import_Archive (Name_FORMATTED)
go

create index memo_FORMATTED
    on Import_Archive (memo_FORMATTED)
go

create index statement_month
    on Import_Archive (statement_month)
go

create index statement_year
    on Import_Archive (statement_year)
go

create table STATEMENT_HEADER_ARCHIVE
(
ARCHIVE_HEADER_ID int identity
    constraint PK_STATEMENT_HEADER_ARCHIVE
        primary key,
HEADER_ID         int not null,
MONTH             varchar(50) not null,
YEAR              int not null,
BROKER_ID         int,
BROKER_NAME       nvarchar(500),
FLAG              int not null,
STATEMENT_TOTAL   numeric(18, 2),
Change_Date       datetime
)
go

create index HEADER_ID
    on STATEMENT_HEADER_ARCHIVE (HEADER_ID)
go

create index BROKER_ID
    on STATEMENT_HEADER_ARCHIVE (BROKER_ID)
go

create index MONTH
    on STATEMENT_HEADER_ARCHIVE (MONTH)
go

create index YEAR
    on STATEMENT_HEADER_ARCHIVE (YEAR)
go

create index FLAG
    on STATEMENT_HEADER_ARCHIVE (FLAG)
go

create index HEADER_ID on dbo.STATEMENT_DETAILS (HEADER_ID);
create index QB_CLIENT_NAME on dbo.STATEMENT_DETAILS (QB_CLIENT_NAME);
create index CLIENT_NAME on dbo.STATEMENT_DETAILS (CLIENT_NAME);
create index BROKER_ID on dbo.STATEMENT_DETAILS (BROKER_ID);
create index BROKER_NAME on dbo.STATEMENT_DETAILS (BROKER_NAME);


create table STATEMENT_DETAILS_ARCHIVE
(
ARCHIVE_DETAIL_ID int identity
    constraint PK_STATEMENT_DETAILS_ARCHIVE
        primary key,
DETAIL_ID         int not null,
HEADER_ID         int not null,
INVOICE_DATE      date,
INVOICE_NUM       nvarchar(500),
QB_CLIENT_NAME    nvarchar(500),
CLIENT_NAME       nvarchar(500),
BROKER_ID         int,
BROKER_NAME       nvarchar(500),
QB_FEE            nvarchar(500),
FEE_MEMO          nvarchar(500),
QUANTITY          int,
COMMISSION_RATE   numeric(18, 2),
UNIT              nvarchar(50),
STATUS            nvarchar(50),
SALES_PRICE       numeric(18, 2),
TOTAL_PRICE       numeric(18, 2),
START_DATE        nvarchar(50),
BROKER_STATUS     nvarchar(50),
OPEN_BALANCE      numeric(18, 2)
)
go

create index HEADER_ID
    on STATEMENT_DETAILS_ARCHIVE (HEADER_ID)
go

create index QB_CLIENT_NAME
    on STATEMENT_DETAILS_ARCHIVE (QB_CLIENT_NAME)
go

create index CLIENT_NAME
    on STATEMENT_DETAILS_ARCHIVE (CLIENT_NAME)
go

create index BROKER_ID
    on STATEMENT_DETAILS_ARCHIVE (BROKER_ID)
go

create index BROKER_NAME
    on STATEMENT_DETAILS_ARCHIVE (BROKER_NAME)
go

alter table  dbo.STATEMENT_DETAILS add month varchar(50);
alter table  dbo.STATEMENT_DETAILS add year int;

alter table  dbo.STATEMENT_DETAILS_ARCHIVE add month varchar(50);
alter table  dbo.STATEMENT_DETAILS_ARCHIVE add year int;


create index month on dbo.STATEMENT_DETAILS(month);
create index year on dbo.STATEMENT_DETAILS(year);

create index month on dbo.STATEMENT_DETAILS_ARCHIVE(month);
create index year on dbo.STATEMENT_DETAILS_ARCHIVE(year);

alter table dbo.Import_OCT add is_deleted int default 0 not null;
create index is_deleted on dbo.Import_OCT(is_deleted);

alter table dbo.Import_Archive add is_deleted int default 0 not null;
create index is_deleted on dbo.Import_Archive(is_deleted);
go
alter table dbo.SENT_INVOICE add STATEMENT_TOTAL numeric default 0 not null;
create index INVOICE_NUM_FORMATTED on dbo.SENT_INVOICE(INVOICE_NUM_FORMATTED);
go
alter table dbo.STATEMENT_HEADER add STATEMENT_PENDING_TOTAL numeric(18, 2) null ;
alter table dbo.STATEMENT_DETAILS add line_payment_status varchar(50) null default null;
alter table dbo.STATEMENT_DETAILS_ARCHIVE add line_payment_status varchar(50) null default null;
