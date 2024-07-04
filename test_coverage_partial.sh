#!/bin/bash

# Create a directory for coverage reports
mkdir -p coverage

# Get the list of changed packages
changed_packages=$(git diff --name-only origin/main | grep -E '^packages/' | cut -d'/' -f2 | sort | uniq)

if [ -z "$changed_packages" ]; then
  echo "No packages changed."
  exit 0
fi

for package in $changed_packages; do
  echo "Running tests for $package"
  cd packages/$package
  flutter test --coverage
  cd ../..

  # Merge package coverage data
  if [ -f packages/$package/coverage/lcov.info ]; then
    lcov --add-tracefile packages/$package/coverage/lcov.info --output-file coverage/lcov.info
  fi
done

# Convert coverage data to lcov format (if necessary)
if [ -f coverage/lcov.info ]; then
  format_coverage --lcov --in=coverage/lcov.info --out=coverage/lcov.info --packages=.packages --report-on=lib
  # Generate HTML report
  genhtml -o coverage coverage/lcov.info
fi
