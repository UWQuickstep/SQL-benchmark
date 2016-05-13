# TPCH on MonetDB

## Usage
First, set up the `monetdb.cfg` file using the ssb data locations for your system.

To create, load, and run you will use the following commands:
```bash

# Note: create.sh will attempt to delete an existing instance of the ssb database to ensure a clean run. This step may not be necessary, especially if you are on the quickstep box.
./create100.sh

# Loads tpch data into tables.
./load100.sh

# Runs each tpch query 5 times, prints runtime.
./run100.sh
```

## General Useful commands which set up Monet.
```bash

# Create a storage area.
monetdbd create /scratch/monet-data
# Set port to access the database on.
monetdbd set port=54322 /scratch/monet-data/
# See the configuration.
monetdbd get all /scratch/monet-data/
monetdbd start /scratch/monet-data

# Create a database in maintenance mode.
monetdb create dbname
# Set the database to usage mode.
monetdb release dbname

# Stop and destroy a database.
monetdb stop dbname
monetdb destory dbname

# Log into the SQL client.
mclient -d dbname -u monetdb
username: monetdb
password: monetdb

mclient -d dbname < 1.sql
# Show execution time.
mclient -d dbname --interactive

# Commands within the client:
# show all tables: \d
# quit: \q

# Set Properties of Monet.
monetdb stop dbname
monetdb set nthreads=1 dbname
monetdb get nthreads dbname
```
