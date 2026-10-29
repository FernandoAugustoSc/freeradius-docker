#!/bin/bash
set -e

sed -i \
    -e "s/FRD_DB_SERVER/${DB_HOST}/g" \
    -e "s/FRD_DB_USER/${DB_USER}/g" \
    -e "s/FRD_DB_PASSWORD/${DB_PASSWORD}/g" \
    -e "s/FRD_DB_NAME/${DB_NAME}/g" \
    -e "s/FRD_DB_PORT/${DB_PORT}/g" \
    /etc/freeradius/mods-available/sql

exec "$@"   