#!/bin/bash

set -e

escapedPath="$(pwd | sed 's/\//\\\//g')"
reportDirectory="$MELOS_ROOT_PATH/coverage_report"
if [ -d "coverage" ]; then
  # combine line coverage info from package tests to a common file
  if [ ! -d $reportDirectory ]; then
    mkdir $reportDirectory
  fi
  echo "Combining coverage files into $reportDirectory/lcov.info"
  sed -e "s/^SF:lib/SF:$escapedPath\/lib/g" -e '$a\' coverage/lcov.info >> "$reportDirectory/lcov.info"
  rm -rf "coverage"
else
  echo "Coverage directory does not exist"
fi
