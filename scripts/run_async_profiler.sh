#!/bin/bash
if [ -z "$1" ]; then
  echo "Usage: ./run_async_profiler.sh <JavaProcessPID>"
  exit 1
fi

echo "Running Async Profiler on PID: $1..."
mkdir -p results
./profilers/async-profiler/build/bin/asprof -d 10 -o flamegraph -f results/flamegraph.html $1
echo "Flame graph saved in results/flamegraph.html"