This directory contains the scripts that are used to run the TPC-H Benchmark on PostgreSQL

# TPC-H on PostgreSQL

## Installing PostgreSQL 9.6

```bash
# Create the Apt repository package list.
echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" > pgdg.list
sudo pgdg.list /etc/apt/sources.list.d
# Import the repository signing key, and update the package list.
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
  sudo apt-key add -
sudo apt-get update
# Install the package.
sudo apt-get install postgresql-9.6 -y
```

## Setup Environment Variables
```bash
# It is recommended to add to ~/.bashrc as well.
export PATH=/usr/lib/postgresql/9.6/bin:$PATH
export PG_DATADIR=/PATH/TO/PG/DATADIR
```

## Initiating PostgreSQL
```bash
# Initialize the database.
pg_ctl initdb -D $PG_DATADIR
# Start the server.
pg_ctl start -D $PG_DATADIR -l $PG_DATADIR/postgres.log
# Create the database.
createdb tpch-100
# Create Role and Database
sudo -u postgres createuser owning_user
sudo -u postgres createdb -O owning_user tpch-100
```

## Configure PostgreSQL
```bash
# Backup the configuration file.
mv $PG_DATADIR/postgresql.conf $PG_DATADIR/postgresql.conf.backup
# Copy the custom configuration file.
cp /PATH/TO/REPO/tpch/postgres/postgresql.conf $PG_DATADIR
# Restart the database.
pg_ctl restart -D $PG_DATADIR
```
