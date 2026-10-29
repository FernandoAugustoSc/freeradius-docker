#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE USER $RADIUS_DB_USER WITH PASSWORD '$RADIUS_DB_PASSWORD';
    GRANT ALL PRIVILEGES ON DATABASE $RADIUS_DB_NAME TO $RADIUS_DB_USER;
    GRANT ALL ON SCHEMA public TO $RADIUS_DB_USER;
    GRANT SELECT ON radcheck, radreply, radusergroup, radgroupcheck, radgroupreply, nas TO $RADIUS_DB_USER;
    GRANT SELECT, INSERT, UPDATE ON radacct, radpostauth, nasreload TO $RADIUS_DB_USER;
    GRANT USAGE, SELECT ON SEQUENCE radcheck_id_seq, radreply_id_seq, radusergroup_id_seq,
        radgroupcheck_id_seq, radgroupreply_id_seq, radacct_radacctid_seq,
        radpostauth_id_seq, nas_id_seq TO $RADIUS_DB_USER;
EOSQL