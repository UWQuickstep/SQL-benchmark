# turn off socket 1

for i in `seq 0 39`;
do
  echo turning on cpu $i ...
  echo 1 > /sys/devices/system/cpu/cpu$i/online
done    

