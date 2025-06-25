#!/bin/bash
set -e

echo "Unzipping demo database..."
unzip -o /docker-entrypoint-initdb.d/demo-medium-20161013.zip -d /tmp/

echo "Importing database..."
psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" < /tmp/demo_medium.sql
