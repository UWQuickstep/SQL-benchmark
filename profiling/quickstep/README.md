# Profile Quickstep


## Flame Graphs

For a good description of what flame graphs are, read (this article)[http://queue.acm.org/detail.cfm?id=2927301].

To summarize:
> A flame graph visualizes a collection of stack traces (aka call stacks), shown as an adjacency diagram with an inverted icicle layout. Flame graphs are commonly used to visualize CPU profiler output, where stack traces are collected using sampling.

### Usage

You'll need a clone of the (FlameGraph repo)[https://github.com/brendangregg/FlameGraph]. 

1  In your quickstep root folder, create a new build directory, `build-profile` or similar.
2  You'll need to modify your `CMakeLists.txt` file. Simply append the `CMakeLists.txt.perf` file to quickstep's `CMakeLists.txt` file. Something like `cat CMakeLists.txt.perf >> ../CMakeLists.txt`
3  Generate Makefiles with a cmake command similar to `CMake.cmd`.
4  Build as normal.
5  Look at `run-perf.sh` for some example usage. The general flow is gather stack trace -> fold stack trace -> generate SVG.

