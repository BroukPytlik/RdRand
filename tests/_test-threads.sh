#!/bin/env bash
# Will run BIN rdrand test with different number of threads.
# If second argument THROUGHPUT_FILE is given,
# then output of the test will be written also to the file 
# as XML Will overwrite file if exists.

BIN="./RdRand"

# Minimum and maximum count of threads tested
MIN=1 
MAX=4

# Duration of each single tested method
DURATION=3

# size of array of 64bit values to be generated at once
CHUNK=2048

# How many times should be the test run for all methods 
# before computing an average throughput
REPETITION=3


##################################################################
# START

if [ $# -lt 1 ] || [ $# -gt 2 ]; then 
  echo "Usage: $0 RNG_OUTPUT_FILE [THROUGHPUT_FILE.xml] (files will be overwritten)"
  exit 1
fi

FILE_STDOUT="$1"

THROUGHPUT_FILE=""
if [ $# -eq 2 ]; then
  THROUGHPUT_FILE="$2"
  echo "<root>"> "$THROUGHPUT_FILE" # empty it
fi

echo "Will test from $MIN to $MAX threads."

for ((THREADS=$MIN ; THREADS<=$MAX ; THREADS++ )); do
  printf "Currently testing $THREADS threads:  "
  date 
  
  CMD="'$BIN' '$FILE_STDOUT' -d $DURATION -c $CHUNK -r $REPETITION -t $THREADS"
  if [ -z "$THROUGHPUT_FILE"  ]; then
    eval $CMD
  else
    printf "<test threads='$THREADS'>\n" >> "$THROUGHPUT_FILE"
    eval "$CMD 2>&1 | tee -a '$THROUGHPUT_FILE'"
    printf "</test>\n" >> "$THROUGHPUT_FILE"
  fi

done
if [ -n "$THROUGHPUT_FILE"  ]; then
  THROUGHPUT_FILE="$2"
  echo "</root>">> "$THROUGHPUT_FILE" # empty it
fi