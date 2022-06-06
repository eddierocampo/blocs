Activacion de Auditoria DDL y ROLE BD seus Laboratorio:
-------------------------------------------------------

1. Se creo el log analytics workspace y el Diagnostic setting para que se guarden los eventos.  
Sub:seus4-lab  
Resource group: rg-seus4-persistence-lab-001  
Log Analytics workspace: wks-BDFlexible-audit  
Diagnostic setting=ds-auditBD-seuslab  

    Nota: recordar que esto se debe borrar despues de tener evidencias.  
2. Bajar el pg_dump del link  
https://www.enterprisedb.com/download-postgresql-binaries
3. Abrir cli y entrar a la ruta en donde instalaron y se encuentra el pg_dump.exe
4. Hacer backups de la BD  
Ejemplo:  
pg_dump -h my-source-server-name -U source-server-username -Fc -d source-databasename -f Z:\Data\Backups\my-database-backup.dump  
Creo que puede ser asi:  
Para las 4 BD de seus lab sería:
    ~~~
    pg_dump -h psql-srseusl9f0ed176.postgres.database.azure.com -U admpgseusl -Fc -d azure_maintenance -f C:\Binarios\BKP\azure_maintenance.dump  
    pg_dump -h psql-srseusl9f0ed176.postgres.database.azure.com -U admpgseusl -Fc -d azure_sys -f C:\Binarios\BKP\azure_sys.dump  
    pg_dump -h psql-srseusl9f0ed176.postgres.database.azure.com -U admpgseusl -Fc -d postgres -f C:\Binarios\BKP\postgres.dump  
    pg_dump -h psql-srseusl9f0ed176.postgres.database.azure.com -U admpgseusl -Fc -d labseus -f C:\Binarios\BKP\labseus.dump  
    ~~~
Lo intenté pero me da el error:  
Hay que validar con un DBA . abrí un chat con Ramon y Eddier pero no veo a Ramon conectado.-------------------------------------------------------------------------------  
"C:\Users\ErikaCarolinaAlamoJa\Desktop\Instaladores\postgresql-14.2-1-windows-x64-binaries\pgsql\bin>pg_dump -h psql-srseusl9f0ed176.postgres.database.azure.com -U admpgseusl -Fc -d azure_maintenance -f C:\Binarios\BKP\azure_maintenance.dump  
Contraseña:
pg_dump: error: la consulta falló: ERROR:  permission denied for table lsnmover  
pg_dump: error: la consulta era: LOCK TABLE public.lsnmover IN ACCESS SHARE MODE"  (ver imagen abajo)  
--------------------------------------------------------------------------------------------------
Link de ejemplos de backups:
https://www.postgresql.org/docs/current/app-pgdump.html
https://www.postgresql.org/docs/current/app-pgrestore.html
5. Ejecutar el precedimiento que indica la documentación para activar auditoria DDL y ROLE
    [aqui](https://docs.microsoft.com/en-us/azure/postgresql/flexible-server/concepts-audit)
6. Ejecutar estas sentencias para generar eventos y probar que si esta activa la auditoria

    ~~~
    CREATE TABLE "t1" (id int);
      
    CREATE ROLE "PruebaSOX" WITH  
    LOGIN  
    NOSUPERUSER  
    NOCREATEDB  
    NOCREATEROLE  
    INHERIT  
    NOREPLICATION  
    CONNECTION LIMIT -1  
    PASSWORD 'password';  
    
    CREATE OR REPLACE PROCEDURE public."PruebaSoxProcedure"(id integer)  
    LANGUAGE 'sql'  
    AS $BODY$  
    INSERT INTO t1 VALUES (id);  
    $BODY$;  
    
    GRANT EXECUTE ON PROCEDURE public."PruebaSoxProcedure" TO "PruebaSOX";   
   
    DROP PROCEDURE public."PruebaSoxProcedure";  
   
    DROP ROLE "PruebaSOX";  
   
    DROP TABLE "t1";  
    ~~~

7.En Azure entrar a la BD y en la opción logs y ejecutar el Query (creo que este puede servir, pero hay que probarlo)  
    `AzureDiagnostics  
    | where ResourceProvider =="MICROSOFT.DBFORPOSTGRESQL"  
    | where Category == "PostgreSQLLogs"  
    | where Message contains "AUDIT:"  
    | where Message contains "DDL"`