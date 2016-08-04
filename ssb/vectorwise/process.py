# Take the raw benchmark output from a quickstep run and average the middle
# three trials and output the results in csv

# The input to this file is a list of floats indicating the run times of queries.
# q0 run time iter1
# q0 run time iter2
# ..
# q0 run time iter NUM_ITER
# q1 run time iter 1
# ..

import sys
import re
import numpy as np

# Each query is ran these many number of times. 
NUM_ITER = 5

def process_file(fname):
  contents = ""
  try:
    with open(fname, 'r') as f:
      content = f.readlines()
    content = [float(x.strip('\n')) for x in content]
    mean_times = []
    for indx in range(0, len(content), NUM_ITER):
      # Note: Vectorwise outputs time in seconds, hence the conversion to millis.
      mean_times.append(1000*np.mean(content[indx:indx + NUM_ITER]))
    print '\n'.join([str(round(i, 2))for i in mean_times])
  except Exception as e:
    print "Failed to open file: " + e
    return -1

def main(args):
  for fname in args[1:]:
    process_file(fname)

if __name__ == "__main__":
  main(sys.argv)
