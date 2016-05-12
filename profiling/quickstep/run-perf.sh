#!/bin/bash
# This script runs quickstep with a given SQL file and creates an SVG flamechart with the name 'QUERY-callgraph.svg'.
# Example: ./run-perf.sh ssb01.sql
# $1 is the query to record against.

# This is a specially compiled version of Quickstep to include perf symbols.
QS="/home/spehlmann/qs/build-perf/quickstep_cli_shell -storage_path=/scratch/spehlmann/SQL-benchmark/ssb/quickstep/store10 -num_workers=10 -worker_affinities=0,4,8,12,16,20,24,28,32,36 -printing_enabled=false"

FLAME_SCRIPT="/home/spehlmann/FlameGraph/flamegraph.pl"

# This is a temporary file containing the stack trace data. It will grow very large very quickly.
PERF_TMP="perf.data"

# Call perf.
perf record -o $PERF_TMP --call-graph fp -- $QS < $1
perf script -i $PERF_TMP | /home/spehlmann/FlameGraph/stackcollapse-perf.pl > "$PERF_TMP.folded"
$FLAME_SCRIPT "$PERF_TMP.folded" > $1-callgraph.svg

# Cleanup temp files.
rm $PERF_TMP $PERF_TMP.folded &>/dev/null
