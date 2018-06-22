# Download pmu tools from https://github.com/andikleen/pmu-tools 
# Make sure you have MSR tools. Check if sudo modprobe msr works
# The bit location for prefetcher is described here: https://software.intel.com/en-us/articles/disclosure-of-hw-prefetcher-control-on-some-intel-processors
# sudo python
# import msr
# msr.writemsr(0x1A4, msr.readmsr(0x1A4) | 1)

