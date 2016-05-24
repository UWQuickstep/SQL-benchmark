This directory contains the scripts that are used to run the Star Schema Benchmark on PostgreSQL

# SSB on PostgreSQL

## Installing PostgreSQL 9.6 Beta 1

```bash
# Download the source code.
wget https://ftp.postgresql.org/pub/source/v9.6beta1/postgresql-9.6beta1.tar.gz
# Untar it.
tar xzvf postgresql-9.6beta1.tar.gz
# Start to build it.
cd postgresql-9.6beta1
./configure --prefix=/fastdisk/postgres-beta
make
make install
```

## Initiating PostgreSQL
```bash
# Initialize the database.
/fastdisk/postgres-beta/bin/pg_ctl -D /fastdisk/postgres-beta-data initdb
# Start the server.
/fastdisk/postgres-beta/bin/pg_ctl -D /fastdisk/postgres-beta-data start -l /fastdisk/postgres.log
# Create the database.
/fastdisk/postgres-beta/bin/createdb ssb100
```

## Configure PostgreSQL
```bash
# Backup the configuration file.
mv /fastdisk/postgres-beta-data/postgresql.conf /fastdisk/postgres-beta-data/postgresql.conf.backup
# Copy the custom configuration file.
cp /PATH/TO/REPO/ssb/postgres/postgresq.conf /fastdisk/postgres-beta-data/
# Restart the database.
/fastdisk/postgres-beta/bin/pg_ctl -D /fastdisk/postgres-beta-data restart
```
