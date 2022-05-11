use Broker_Commission;
Go;

alter table dbo.[SENT_INVOICE]
    add INVOICE_NUM_FORMATTED
        as
            LTRIM(
                    RTRIM(
                            UPPER( INVOICE_NUM )
                        )
                ) PERSISTED;
Go
create index INVOICE_NUM_FORMATTED on dbo.SENT_INVOICE (INVOICE_NUM_FORMATTED);
go
alter table dbo.[Import_OCT]
    add NUM_FORMATTED
        as
            LTRIM(
                    RTRIM(
                            UPPER( Num )
                        )
                ) PERSISTED;
Go

alter table dbo.[Import_OCT]
    add memo_FORMATTED
        as
            LTRIM(
                    RTRIM(
                            UPPER( Memo )
                        )
                ) PERSISTED;
Go

alter table dbo.[Import_OCT]
    add Agent_FORMATTED
        as
            REPLACE(
                    REPLACE(
                            REPLACE(
                                    REPLACE(
                                            REPLACE(
                                                    REPLACE(
                                                            LTRIM(
                                                                    RTRIM(
                                                                            UPPER( Agent )
                                                                        )
                                                                ) , '&' , '' ) ,
                                                    ',' , '' ) ,
                                            '.' , '' ) ,
                                    ' - ' , '-' ) ,
                            '- ' , '-' ) ,
                    '-' , '' ) PERSISTED;
Go

alter table dbo.[Import_OCT]
    add Name_FORMATTED
        as
            REPLACE(
                    REPLACE(
                            REPLACE(
                                    REPLACE(
                                            REPLACE(
                                                    REPLACE(
                                                            LTRIM(
                                                                    RTRIM(
                                                                            UPPER( Name )
                                                                        )
                                                                ) , '&' , '' ) ,
                                                    ',' , '' ) ,
                                            '.' , '' ) ,
                                    ' - ' , '-' ) ,
                            '- ' , '-' ) ,
                    '-' , '' ) PERSISTED;
Go

create index NUM_FORMATTED on dbo.Import_OCT (NUM_FORMATTED);
create index Agent_FORMATTED on dbo.Import_OCT (Agent_FORMATTED);
create index Name_FORMATTED on dbo.Import_OCT (Name_FORMATTED);
create index memo_FORMATTED on dbo.Import_OCT (Memo_FORMATTED);

alter table dbo.Import_OCT add created_at datetime default  current_timestamp;
