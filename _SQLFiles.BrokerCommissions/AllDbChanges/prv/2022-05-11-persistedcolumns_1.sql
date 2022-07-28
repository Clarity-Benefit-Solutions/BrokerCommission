use Broker_Commission;
Go;

alter table [BROKER_MASTER]
    add BROKER_NAME_ID_FORMATTED
        as
            REPLACE(
                    REPLACE(
                            REPLACE(
                                    REPLACE(
                                            REPLACE(
                                                    REPLACE(
                                                            LTRIM(
                                                                    RTRIM(
                                                                            UPPER( BROKER_NAME_ID )
                                                                        )
                                                                ) , '&' , '' ) ,
                                                    ',' , '' ) ,
                                            '.' , '' ) ,
                                    ' - ' , '-' ) ,
                            '- ' , '-' ) ,
                    '-' , '' ) PERSISTED;;
;
alter table [BROKER_MASTER]
    add BROKER_NAME_FORMATTED
        as
            REPLACE(
                    REPLACE(
                            REPLACE(
                                    REPLACE(
                                            REPLACE(
                                                    REPLACE(
                                                            LTRIM(
                                                                    RTRIM(
                                                                            UPPER( BROKER_NAME )
                                                                        )
                                                                ) , '&' , '' ) ,
                                                    ',' , '' ) ,
                                            '.' , '' ) ,
                                    ' - ' , '-' ) ,
                            '- ' , '-' ) ,
                    '-' , '' ) PERSISTED;
Go
alter table [BROKER_MASTER]
    add BROKER_NAME_1_FORMATTED
        as
            REPLACE(
                    REPLACE(
                            REPLACE(
                                    REPLACE(
                                            REPLACE(
                                                    REPLACE(
                                                            LTRIM(
                                                                    RTRIM(
                                                                            UPPER( BROKER_NAME_1 )
                                                                        )
                                                                ) , '&' , '' ) ,
                                                    ',' , '' ) ,
                                            '.' , '' ) ,
                                    ' - ' , '-' ) ,
                            '- ' , '-' ) ,
                    '-' , '' ) PERSISTED;
Go
alter table [BROKER_MASTER]
    add BROKER_NAME_2_FORMATTED
        as
            REPLACE(
                    REPLACE(
                            REPLACE(
                                    REPLACE(
                                            REPLACE(
                                                    REPLACE(
                                                            LTRIM(
                                                                    RTRIM(
                                                                            UPPER( BROKER_NAME_2 )
                                                                        )
                                                                ) , '&' , '' ) ,
                                                    ',' , '' ) ,
                                            '.' , '' ) ,
                                    ' - ' , '-' ) ,
                            '- ' , '-' ) ,
                    '-' , '' ) PERSISTED;
Go
alter table [BROKER_MASTER]
    add BROKER_NAME_3_FORMATTED
        as
            REPLACE(
                    REPLACE(
                            REPLACE(
                                    REPLACE(
                                            REPLACE(
                                                    REPLACE(
                                                            LTRIM(
                                                                    RTRIM(
                                                                            UPPER( BROKER_NAME_3 )
                                                                        )
                                                                ) , '&' , '' ) ,
                                                    ',' , '' ) ,
                                            '.' , '' ) ,
                                    ' - ' , '-' ) ,
                            '- ' , '-' ) ,
                    '-' , '' ) PERSISTED;
Go
alter table [BROKER_MASTER]
    add BROKER_NAME_4_FORMATTED
        as
            REPLACE(
                    REPLACE(
                            REPLACE(
                                    REPLACE(
                                            REPLACE(
                                                    REPLACE(
                                                            LTRIM(
                                                                    RTRIM(
                                                                            UPPER( BROKER_NAME_4 )
                                                                        )
                                                                ) , '&' , '' ) ,
                                                    ',' , '' ) ,
                                            '.' , '' ) ,
                                    ' - ' , '-' ) ,
                            '- ' , '-' ) ,
                    '-' , '' ) PERSISTED;
Go

alter table [BROKER_MASTER]
    add BROKER_NAME_5_FORMATTED
        as
            REPLACE(
                    REPLACE(
                            REPLACE(
                                    REPLACE(
                                            REPLACE(
                                                    REPLACE(
                                                            LTRIM(
                                                                    RTRIM(
                                                                            UPPER( BROKER_NAME_5 )
                                                                        )
                                                                ) , '&' , '' ) ,
                                                    ',' , '' ) ,
                                            '.' , '' ) ,
                                    ' - ' , '-' ) ,
                            '- ' , '-' ) ,
                    '-' , '' ) PERSISTED;
Go

alter table [BROKER_MASTER]
    add BROKER_NAME_6_FORMATTED
        as
            REPLACE(
                    REPLACE(
                            REPLACE(
                                    REPLACE(
                                            REPLACE(
                                                    REPLACE(
                                                            LTRIM(
                                                                    RTRIM(
                                                                            UPPER( BROKER_NAME_6 )
                                                                        )
                                                                ) , '&' , '' ) ,
                                                    ',' , '' ) ,
                                            '.' , '' ) ,
                                    ' - ' , '-' ) ,
                            '- ' , '-' ) ,
                    '-' , '' );
Go

create index PAYLOCITY_ID on dbo.BROKER_MASTER (PAYLOCITY_ID);
create index EMAIL on dbo.BROKER_MASTER (EMAIL);
create index SECONDARY_EMAIL on dbo.BROKER_MASTER (SECONDARY_EMAIL);
create index STATUS on dbo.BROKER_MASTER (STATUS);

create index BROKER_NAME_ID_FORMATTED on dbo.BROKER_MASTER (BROKER_NAME_ID_FORMATTED);
create index BROKER_NAME on dbo.BROKER_MASTER (BROKER_NAME);
create index BROKER_NAME_1 on dbo.BROKER_MASTER (BROKER_NAME_1);
create index BROKER_NAME_2 on dbo.BROKER_MASTER (BROKER_NAME_2);
create index BROKER_NAME_3 on dbo.BROKER_MASTER (BROKER_NAME_3);
create index BROKER_NAME_4 on dbo.BROKER_MASTER (BROKER_NAME_4);
create index BROKER_NAME_5 on dbo.BROKER_MASTER (BROKER_NAME_5);
create index BROKER_NAME_6 on dbo.BROKER_MASTER (BROKER_NAME_6);

create index BROKER_NAME_FORMATTED ON dbo.BROKER_MASTER (BROKER_NAME_FORMATTED);
create index BROKER_NAME_1_FORMATTED ON dbo.BROKER_MASTER (BROKER_NAME_1_FORMATTED);
create index BROKER_NAME_2_FORMATTED ON dbo.BROKER_MASTER (BROKER_NAME_2_FORMATTED);
create index BROKER_NAME_3_FORMATTED ON dbo.BROKER_MASTER (BROKER_NAME_3_FORMATTED);
create index BROKER_NAME_4_FORMATTED ON dbo.BROKER_MASTER (BROKER_NAME_4_FORMATTED);
create index BROKER_NAME_5_FORMATTED ON dbo.BROKER_MASTER (BROKER_NAME_5_FORMATTED);
create index BROKER_NAME_6_FORMATTED ON dbo.BROKER_MASTER (BROKER_NAME_6_FORMATTED);

GO


create index AGENT_ID on dbo.BROKER_GROUP (AGENT_ID);
create index BROKER_GROUP on dbo.BROKER_GROUP (BROKER_GROUP);
create index AGENT on dbo.BROKER_GROUP (AGENT);

GO

ALTER TABLE CLIENT
    ADD QB_CLIENT_NAME_FORMATTED AS
        REPLACE(
                REPLACE(
                        REPLACE(
                                REPLACE(
                                        REPLACE(
                                                REPLACE(
                                                        LTRIM(
                                                                RTRIM(
                                                                        UPPER( QB_CLIENT_NAME )
                                                                    )
                                                            ) , '&' , '' ) ,
                                                ',' , '' ) ,
                                        '.' , '' ) ,
                                ' - ' , '-' ) ,
                        '- ' , '-' ) ,
                '-' , '' );

ALTER TABLE CLIENT
    ADD QB_FEE_FORMATTED AS
        LTRIM(
                RTRIM(
                        UPPER( QB_FEE )
                    )
            ) PERSISTED;

create index QB_FEE_FORMATTED_FORMATTED on dbo.CLIENT (QB_FEE_FORMATTED);
create index QB_CLIENT_NAME_FORMATTED on dbo.CLIENT (QB_CLIENT_NAME_FORMATTED);


go
create index HEADER_ID on dbo.STATEMENT_HEADER (HEADER_ID);
create index BROKER_ID on dbo.STATEMENT_HEADER (BROKER_ID);
create index MONTH on dbo.STATEMENT_HEADER (MONTH);
create index YEAR on dbo.STATEMENT_HEADER (YEAR);
create index FLAG on dbo.STATEMENT_HEADER (FLAG);
go

