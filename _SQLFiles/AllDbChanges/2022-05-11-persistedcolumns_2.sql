use Broker_Commission;
Go;

alter table dbo.[Import_OCT]
    add NUM_FORMATTED
        as
            LTRIM(
                    RTRIM(
                            UPPER( Num )
                        )
                );
Go

alter table dbo.[Import_OCT]
    add memo_FORMATTED
        as
            LTRIM(
                    RTRIM(
                            UPPER( Memo )
                        )
                );
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
                    '-' , '' );
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
                    '-' , '' );
Go

create index NUM_FORMATTED on dbo.Import_OCT (NUM_FORMATTED);
create index Agent_FORMATTED on dbo.Import_OCT (Agent_FORMATTED);
create index Name_FORMATTED on dbo.Import_OCT (Name_FORMATTED);
create index memo_FORMATTED on dbo.Import_OCT (Memo_FORMATTED);
