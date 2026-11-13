#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username $POSTGRES_USER --dbname "postgres" <<-EOSQL
    CREATE DATABASE $POSTGRES_DATABASE;

EOSQL

psql -v ON_ERROR_STOP=1 --username $POSTGRES_USER --dbname $POSTGRES_DATABASE \
  -f /docker-entrypoint-initdb.d/schema.sql

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DATABASE" <<-EOSQL
    CREATE USER $RADIUS_DATABASE_USER WITH PASSWORD '$RADIUS_DATABASE_PASSWORD';
    GRANT ALL PRIVILEGES ON DATABASE $POSTGRES_DATABASE TO $RADIUS_DATABASE_USER;
    GRANT ALL ON SCHEMA public TO $RADIUS_DATABASE_USER;
    GRANT SELECT ON radcheck, radreply, radusergroup, radgroupcheck, radgroupreply, nas TO $RADIUS_DATABASE_USER;
    GRANT SELECT, INSERT, UPDATE ON radacct, radpostauth, nasreload TO $RADIUS_DATABASE_USER;
    GRANT USAGE, SELECT ON SEQUENCE radcheck_id_seq, radreply_id_seq, radusergroup_id_seq,
        radgroupcheck_id_seq, radgroupreply_id_seq, radacct_radacctid_seq,
        radpostauth_id_seq, nas_id_seq TO $RADIUS_DATABASE_USER;
EOSQL