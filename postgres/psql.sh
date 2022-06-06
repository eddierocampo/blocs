# Connections to db
psql -h <name_host> -d <name_db> -p 5432 -U <user>
psql -h db-cotizador-v00.ctoogdwyol14.us-east-1.rds.amazonaws.com -d postgres -p 5432 -U dbadmin

# List all dabases
\l
SELECT datname FROM pg_database;

# Connect DB
\c <name_db>

# List schemas
\dn

# exit
\q

SELECT * FROM tcot_cotizacion_salud where nmcotizacion = '11310146220405134448';