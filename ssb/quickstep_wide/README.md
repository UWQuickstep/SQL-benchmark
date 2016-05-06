# Widetable quickstep.

- To run: edit the environment variables at the top of the `run-sf100.sh` or `run-sf1.sh` depending on which scale factor you wish to run. Descriptions of what the variables do are included in those files.

- The `process.py` script can be used to quickly calculate the average of the middle three runs from the output of the run scripts.

Example:
```bash
./run1.sh > sf1.out
python process.py sf1.out
```