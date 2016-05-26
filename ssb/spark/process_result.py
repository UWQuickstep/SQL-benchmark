import sys
import csv

from collections import defaultdict
print sys.argv[1]
query_times=defaultdict(list)
with open(sys.argv[1]) as csvfile:
  reader = csv.reader(csvfile)
  for row in reader:
      for  i in xrange(1,len(row)):
           query_times[i].append(row[i])

print query_times
print "****"
run_times=[sum(sorted([float(x) for x in value])[:3])/3 for (key, value) in query_times.items()]

print "*******************************"
print "*  Query Run Times            *"
print "*******************************"
for times in run_times:
    print times
