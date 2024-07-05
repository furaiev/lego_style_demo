#!/bin/bash

# Ensure melos is installed
if ! command -v melos &> /dev/null; then
  echo "Melos could not be found. Please install Melos first."
  exit 1
fi

# Ensure lcov is installed
if ! command -v lcov &> /dev/null; then
  echo "lcov could not be found. Please install lcov."
  exit 1
fi

# Ensure genhtml is installed
if ! command -v genhtml &> /dev/null; then
  echo "genhtml could not be found. Please install lcov (genhtml is part of lcov)."
  exit 1
fi

# Create a directory for coverage reports
mkdir -p coverage

# Generate baseline coverage report from the main branch
git fetch origin
git checkout origin/main
flutter test --coverage

# Move the baseline coverage report to a temporary file
if [ -f coverage/lcov.info ]; then
  mv coverage/lcov.info coverage/lcov.baseline.info
else
  echo "Baseline coverage report not found."
  exit 1
fi

# Switch back to the current branch
git checkout -

# Get the list of changed packages
changed_packages=$(git diff --name-only origin/main | grep -E '^feature/' | cut -d'/' -f2 | sort | uniq)

if [ -z "$changed_packages" ]; then
  echo "No packages changed."
  exit 0
fi

# Initialize a temporary lcov.info file for merging
echo "Creating initial lcov.info for merging"
echo "" > coverage/lcov.info

# Run tests and collect coverage for each changed package
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

# Merge the baseline coverage with the new coverage data
if [ -s coverage/lcov.info ]; then
  echo "Merging baseline coverage with new coverage data"
  lcov --add-tracefile coverage/lcov.baseline.info --add-tracefile coverage/lcov.info --output-file coverage/lcov.merged.info
  mv coverage/lcov.merged.info coverage/lcov.info
  rm coverage/lcov.baseline.info
else
  echo "No new coverage data collected, using baseline coverage only"
  mv coverage/lcov.baseline.info coverage/lcov.info
fi

# Generate HTML report
if [ -s coverage/lcov.info ]; then
  echo "Generating HTML report"
  genhtml -o coverage coverage/lcov.info
else
  echo "No coverage data collected."
fi

# Clean up temporary files
rm -f coverage/lcov.temp.info

echo "Coverage report generated in the coverage directory."
