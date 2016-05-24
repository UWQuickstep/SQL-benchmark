# turn off socket 1

for i in `seq 10 19`;
do
  echo turning off cpu $i ...
  echo 0 > /sys/devices/system/cpu/cpu$i/online
done    

for i in `seq 30 39`;
do
  echo turning off cpu $i ...
  echo 0 > /sys/devices/system/cpu/cpu$i/online
done    
