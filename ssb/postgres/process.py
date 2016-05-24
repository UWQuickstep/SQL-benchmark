# Take the raw benchmark output from a quickstep run and average the middle
# three trials and output the results in csv

import sys
import re

patt = re.compile(ur'QUERY (\d+)|Time: (\d+\.\d+) ms')

def avg(arr):
  sum = 0.0
  for i in arr:
    sum += i
  return sum / len(arr)

def process_file(fname):
  contents = ""
  try:
    f = open(fname, 'r')
    contents = f.read()
    f.close()
  except Exception as e:
    print "Failed to open file: " + e
    return -1

  current_query = 0
  query_avg = {}
  counts = []
  for match in re.findall(patt, contents):
    if match[0]:
      if current_query != 0:
        query_avg[current_query] = round(avg(counts[1:-1]), 2)
      counts = []
      current_query = int(match[0])
    else:
      counts.append(float(match[1]))
  query_avg[current_query] = round(avg(counts[1:-1]), 2)

  for k in query_avg:
    #print "{},{}".format(k, query_avg[k])
    print "{}".format(query_avg[k])

def main(args):
  for fname in args[1:]:
    process_file(fname)

if __name__ == "__main__":
  main(sys.argv)
