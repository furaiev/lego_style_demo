#!/bin/bash

# Ensure melos is installed
if ! command -v melos &> /dev/null; then
  echo "Melos could not be found. Please install Melos first."
  exit 1
fi

# Create a directory for coverage reports
mkdir -p coverage

# Get the list of changed packages
changed_packages=$(git diff --name-only origin/main | grep -E '^feature/' | cut -d'/' -f2 | sort | uniq)

if [ -z "$changed_packages" ]; then
  echo "No packages changed."
  exit 0
fi

# Initialize a temporary lcov.info file for merging
echo "Creating initial lcov.info for merging"
echo "" > coverage/lcov.info

for package in $changed_packages; do
  echo "Running tests for $package"
  cd feature/$package
  flutter test --coverage
  cd ../..

  # Merge package coverage data
  if [ -f feature/$package/coverage/lcov.info ]; then
    echo "Merging coverage for $package"
    lcov --add-tracefile feature/$package/coverage/lcov.info --output-file coverage/lcov.temp.info
    mv coverage/lcov.temp.info coverage/lcov.info
  fi
done

# Convert coverage data to lcov format (if necessary)
if [ -s coverage/lcov.info ]; then
  echo "Converting and generating HTML report"
  format_coverage --lcov --in=coverage/lcov.info --out=coverage/lcov.info --packages=.packages --report-on=lib
  genhtml -o coverage coverage/lcov.info
else
  echo "No coverage data collected."
fi

# Clean up temporary files
rm -f coverage/lcov.temp.info

echo "Coverage report generated in the coverage directory."
