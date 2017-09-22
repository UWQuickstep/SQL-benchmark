# TPC-H on QuickStep
This directory contains the scripts that are used to run the TPCH on Quickstep.

## Usage

- Create a `.cfg` file with the correct parameters for your system. Use the `quickstep.cfg` file for guidence.
- run `./run-benchmark.sh your-cfg-file.cfg`
- The `process.py` script can be used to extract the average of the middle 3 trials of the resultant output from `run-benchmark.sh`

This is an example of how to use the entire pipeline:
```bash
./run-benchmark.sh quickstep.cfg > my_output.out
python process.py my_output.out
```

## Configuration

Here is an example config file:
```bash
# Path to Quickstep cli shell.
QS=/home/spehlmann/qs/build/quickstep_cli_shell

QS_ARGS_BASE="-printing_enabled=false -aggregate_hashtable_type=SeparateChaining"

# This is the flags to Quickstep during the loading process. Worker affinities must
# not be set if your system does not support NUMA. The num_workers flag should be set
# to the number of cores on you system. The reason there's two flags for loading and
# running is that loading has memory problems for large number of workers.
QS_ARGS_NUMA_LOAD="-num_workers=10 -worker_affinities=0,4,8,12,16,20,24,28,32,36"

# This is the flags to Quickstep during the benchmarking runs. Worker affinities must
# not be set if your system does not support NUMA. The num_workers flag should be set
# to the number of cores on you system.
QS_ARGS_NUMA_RUN="-num_workers=40 -worker_affinities=0,4,8,12,16,20,24,28,32,36,1,5,9,13,17,21,25,29,33,37,2,6,10,14,18,22,26,30,34,38,3,7,11,15,19,23,27,31,35,39"

# This is the script to use to create the TPC-H tables. Probably doesn't need to be modified
# unless you are testing different block formats.
CREATE_SQL="create.sql"

# If set to false, then QuickStep will not attempt to load tables.
# If true, the script will delete anything in QS_STORAGE and load everything freshly.
# It will need to be set to true the first time you run it.
LOAD_DATA=true

# Paths to tbl files for bulk loading. Probably to your table generate or subfolder.
# This path must be set if you are loading data. Table file come from the standard
# TPCH data generator which can be found on github.
TPCH_DATA_PATH=/scratch/benchmark-data/tpch

# Where Quickstep will write Storage Blocks to.
QS_STORAGE=store10

```
