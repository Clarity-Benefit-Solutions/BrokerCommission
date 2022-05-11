use Broker_Commission;

/*A  UI: user clicks Upload Raw Data*/
/* 1. call SP_FILE_IMPORT_SSIS */
/* 1.1 this call SP_UPLODADFILE*/
/* 1.1.1 this call job Broker_Commission which
   truncates table Import_OCT
   imports file from "E:\BROKER_COMMISSION_OUTPUT\file_import.csv" in same machine as sql server into table Import_OCT*/

/*
-- ENHANCEMNT: fix columns by running new Sp
update [dbo].[BROKER_CLIENT]
set
    QB_BROKER_NAME = LTRIM( RTRIM( UPPER( REPLACE( QB_BROKER_NAME , '&' , '' ) ) ) ),
    QB_CLIENT_NAME = REPLACE( REPLACE( REPLACE( REPLACE( REPLACE(
                                                                 REPLACE( LTRIM( RTRIM( UPPER( QB_CLIENT_NAME ) ) ) , '&' , '' ) ,
                                                                 ',' , '' ) , '.' , '' ) , ' - ' , '-' ) , '- ' ,
                                       '-' ) , '-' , '' ),
    QB_FEE         = LTRIM( RTRIM( UPPER( QB_FEE ) ) );

--
;
update dbo.Import_OCT
set
    Agent= REPLACE( REPLACE( REPLACE( REPLACE(
                                              REPLACE( REPLACE( LTRIM( RTRIM( UPPER( Agent ) ) ) , '&' , '' ) , ',' , '' ) ,
                                              '.' , '' ) , ' - ' , '-' ) , '- ' , '-' ) , '-' , '' )
  , [Name] = REPLACE( REPLACE( REPLACE( REPLACE(
                                                REPLACE( REPLACE( LTRIM( RTRIM( UPPER( [Name] ) ) ) , '&' , '' ) , ',' ,
                                                         '' ) , '.' , '' ) , ' - ' , '-' ) , '- ' , '-' ) , '-' , '' )
  , memo = LTRIM( RTRIM( UPPER( Memo ) ) );
 */
go

