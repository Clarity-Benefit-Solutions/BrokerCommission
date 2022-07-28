use Broker_Commission;
go
-- auto-generated definition
create table Client_Prv
(
CLIENT_ID                int identity
    constraint PK_CLIENT_prv_IMPORT_10222021
        primary key,
QB_CLIENT_NAME           nvarchar(500),
CLIENT_NAME              nvarchar(500),
BROKER_ID                int,
QB_FEE                   nvarchar(500),
FEE_MEMO                 nvarchar(500),
COMMISSION_RATE          numeric(18, 2),
UNIT                     nvarchar(50),
STATUS                   nvarchar(50),
FEE                      nvarchar(50),
START_DATE               nvarchar(50),
QB_CLIENT_NAME_FORMATTED as replace( replace( replace( replace( replace(
                                                                        replace( ltrim( rtrim( upper( [QB_CLIENT_NAME] ) ) ) , '&' , '' ) ,
                                                                        ',' , '' ) , '.' , '' ) , ' - ' , '-' ) , '- ' ,
                                              '-' ) , '-' , '' ),
QB_FEE_FORMATTED         as ltrim( rtrim( upper( [QB_FEE] ) ) ),
created_at               datetime2
    constraint CLIENT_Prv_created_at default getdate( ) not null,
created_by               nvarchar(200)
    constraint CLIENT_Prv_created_by default user_name( )
)
go

create index QB_FEE_FORMATTED_FORMATTED
    on Client_Prv (QB_FEE_FORMATTED)
go

create index QB_CLIENT_NAME_FORMATTED
    on Client_Prv (QB_CLIENT_NAME_FORMATTED)
go

set identity_insert Client_Prv On;
go
insert into Client_Prv
(
    CLIENT_ID
,   QB_CLIENT_NAME
,   CLIENT_NAME
,   BROKER_ID
,   QB_FEE
,   FEE_MEMO
,   COMMISSION_RATE
,   UNIT
,   STATUS
,   FEE
,   START_DATE
,   created_at
,   created_by
)
select
    CLIENT_ID
  , QB_CLIENT_NAME
  , CLIENT_NAME
  , BROKER_ID
  , QB_FEE
  , FEE_MEMO
  , COMMISSION_RATE
  , UNIT
  , STATUS
  , FEE
  , START_DATE
  , created_at
  , created_by
from
    dbo.Client;

go

set identity_insert Client_Prv Off;
go

alter table Fee_Memo
    drop constraint PK_Memo_Name
go

alter table Fee_Memo
    drop column ID
go

/* remove duplicates*/
select *
from
    fee_memo
where
        MEMO in (
                    select
                        memo
                    from
                        dbo.Fee_Memo
                    group by
                        memo
                    having
                        count( * ) > 1
                )
order by
    Fee_Memo.MEMO;

alter table Fee_Memo
    alter column MEMO nvarchar(255) not null
go


alter table Fee_Memo
    add constraint [Fee_Memo_pk]
        primary key nonclustered (MEMO)
go


create table Client_Memo_Broker
(
Client_Memo_Broker_ID int identity
    constraint PK_ClientMemo_IMPORT
        primary key,
CLIENT_ID             int,
MEMO                  nvarchar(255)
);
go

alter table Client_Memo_Broker
    add constraint FK_Client_Memo_Broker_Memo
        foreign key (MEMO)
            references Fee_Memo (MEMO)
go


alter table Client_Memo_Broker
    add constraint FK_Client_Memo_Broker_Client
        foreign key (CLIENT_ID)
            references dbo.Client (CLIENT_ID)
go


create unique index memo on dbo.Fee_Memo (MEMO);
go

create table Client_Memo_Broker
(
CLIENT_ID       int not null,
MEMO            nvarchar(255) not null,
BROKER_ID       int not null,
COMMISSION_RATE numeric(18, 2),
UNIT            nvarchar(50),
STATUS          nvarchar(50),
FEE             nvarchar(50),
START_DATE      datetime2,
created_at      datetime2
    default getdate( ) not null,
created_by      nvarchar(200)
    default user_name( )
);
go

create unique index Client_Memo_Broker on Client_Memo_Broker (CLIENT_ID, MEMO, BROKER_ID);

alter table Client_Memo_Broker
    add constraint FK_Client_Memo_Broker_Memo
        foreign key (MEMO)
            references Fee_Memo (MEMO)
go


alter table Client_Memo_Broker
    add constraint FK_Client_Memo_Broker_Client
        foreign key (CLIENT_ID)
            references dbo.Client (CLIENT_ID)
go

alter table Client_Memo_Broker
    add constraint FK_Client_Memo_Broker_Broker
        foreign key (BROKER_ID)
            references dbo.Broker_Master (ID)
go



create unique index memo on dbo.Fee_Memo (MEMO);

alter table Client
    drop column BROKER_ID
go

alter table Client
    drop column FEE
go

drop index QB_FEE_FORMATTED_FORMATTED on Client
go

alter table Client
    drop column QB_FEE_FORMATTED
go


alter table Client
    drop column QB_FEE
go

alter table Client
    drop column FEE_MEMO
go

alter table Client
    drop column COMMISSION_RATE
go

alter table Client
    drop column UNIT
go


alter table Client
    add START_DATE2 datetime2 null
go


CREATE FUNCTION dbo.isblank(
    @string nvarchar(max) ) RETURNS bit AS
    /* simulate missing Access fn */
BEGIN
    IF @string IS NULL OR @string = '' OR dbo.TRIM( @string ) = ''
        BEGIN
            RETURN 1
        END
    
    RETURN 0;
END
GO

CREATE FUNCTION dbo.isnotblank(
    @string nvarchar(max) ) RETURNS bit AS
    /* simulate missing Access fn */
BEGIN
    IF @string IS NULL OR @string = '' OR dbo.TRIM( @string ) = ''
        BEGIN
            RETURN 0
        END
    
    RETURN 1;
END
GO

CREATE FUNCTION dbo.trim(
    @string nvarchar(max) ) RETURNS nvarchar(max) AS
    /* simulate missing Access fn */
BEGIN
    RETURN LTRIM( RTRIM( @string ) )
END
GO

CREATE FUNCTION dbo.cdateiso(
    @string nvarchar(100) ) RETURNS date AS
    /* simulate missing Access fn */
BEGIN
    DECLARE @datestr nvarchar(200) = NULL;
    DECLARE @datevalue date = NULL;
    
    SET @datestr = SUBSTRING( @string , 5 , 2 ) + '/' + RIGHT( @string , 2 ) + '/' + LEFT( @string , 4 )
    
    SET @datevalue = ISNULL( TRY_CAST( @datestr AS date ) , NULL );
    
    RETURN @datevalue;
END
GO
CREATE FUNCTION dbo.cdateus(
    @string nvarchar(100) ) RETURNS date AS
    /* simulate missing Access fn */
BEGIN
    declare @datevalue datetime2;
    
    SET @datevalue = ISNULL( TRY_CAST( @string AS date ) , NULL );
    
    RETURN @datevalue;
END
GO

CREATE FUNCTION dbo.cmoney(
    @string nvarchar(100) ) RETURNS money AS
    /* simulate missing Access fn */
BEGIN
    DECLARE @moneyval money = 0.00;
    
    SET @moneyval = ISNULL( TRY_CAST( @string AS money ) , 0.00 );
    
    RETURN @moneyval;
END
GO

/*update date field*/
update client
set
    Client.START_DATE2 = dbo.cdateus( START_DATE );
GO

/* find data errors*/
select *
from
    dbo.Client
where
      dbo.isnotblank( START_DATE ) = 1
  and Client.START_DATE2 is null;
go
alter table Client
    drop column START_DATE
go

exec sp_rename 'Client.START_DATE2' , START_DATE , 'COLUMN'
go

/* migrate data to newe stucture*/
select *
from
    Client_Prv
where
    dbo.isblank( FEE_MEMO ) = 1;
go

/* migrate data to new structure*/

/* add missing memos*/
alter table Fee_Memo
    drop column CLIENT_ID
go
go
alter table Client_Memo_Broker
    drop constraint FK_Client_Memo_Broker_Memo
go

delete
from
    Client_Memo_Broker;

insert into Client_Memo_Broker (
                               CLIENT_ID,
                               MEMO,
                               BROKER_ID,
                               COMMISSION_RATE,
                               UNIT,
                               status
)
select distinct
    CLIENT_ID
  , FEE_MEMO
  , BROKER_ID
  , COMMISSION_RATE
  , UNIT
  , 1
from
    Client_Prv
where
      dbo.isblank( FEE_MEMO ) = 0
  and BROKER_ID is not null
  and BROKER_ID in (
                       Select
                           ID
                       from
                           dbo.Broker_Master
                   );

go

drop table #temp_missing_memo;
go
select distinct
    dbo.trim( fee_memo ) fee_memo
into #temp_missing_memo
from
    Client_Prv
where
        FEE_MEMO not in (
                            select
                                memo
                            from
                                dbo.Fee_Memo
                        );

go

insert into dbo.Fee_Memo (
                         memo,
                         commisionable
)
select
    fee_memo
  , 1
from
    #temp_missing_memo
where
        fee_memo not in (
                            select
                                memo
                            from
                                dbo.Fee_Memo
                        );
go

select
    MEMO
from
    Client_Memo_Broker
where
        memo not in (
                        select
                            memo
                        from
                            dbo.Fee_Memo
                    );

/* add manually*/
select *
from
    dbo.Fee_Memo;
/**/
alter table Client_Memo_Broker
    add constraint FK_Client_Memo_Broker_Memo
        foreign key (MEMO)
            references Fee_Memo (MEMO)
go

create or alter view vw_Client_Memo_Broker
as
    select
        c.CLIENT_ID
      , c.CLIENT_NAME
      , cmb.COMMISSION_RATE
      , cmb.UNIT
      , cmb.STATUS
      , bm.ID BROKER_ID
      , bm.BROKER_NAME
      , bm.PAYLOCITY_ID
      , fm.MEMO
      , fm.COMMISIONABLE
    from
        dbo.Client c
            inner join Client_Memo_Broker cmb on c.CLIENT_ID = cmb.CLIENT_ID
            inner join Broker_Master bm on cmb.BROKER_ID = bm.id
            inner join Fee_Memo fm on cmb.MEMO = fm.MEMO;

go
select *
from
    vw_Client_Memo_Broker;
