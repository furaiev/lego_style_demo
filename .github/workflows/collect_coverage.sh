#!/bin/bash

# Check if dart_test.yaml file exists
if [ ! -f dart_test.yaml ]; then
  # Check if the project is a Flutter project
  if grep -q 'flutter:' pubspec.yaml; then
    echo 'Running very_good test with coverage...'
    very_good test --coverage --exclude-tags=golden
  else
    echo 'Running dart pub global run coverage:test_with_coverage...'
    dart pub global run coverage:test_with_coverage
  fi

  echo 'Removing unnecessary files from coverage report...'
  dart pub global run remove_from_coverage:remove_from_coverage -f coverage/lcov.info -r '.g.dart$' -r '.gr.dart$' -r '.freezed.dart$' -r '.i69n.dart$' -r 'di_initializer.config.dart'

  # Set and print the COVERAGE_FILE variable
  COVERAGE_FILE="coverage/lcov.info"
  echo "COVERAGE_FILE is set to: ${COVERAGE_FILE}"

  TEMP_FILE=$(mktemp)
  ROOT=$(pwd)
  GIT_ROOT=$(git rev-parse --show-toplevel)
  PROJECT_ROOT=$(echo "$CURRENT_DIR" | sed "s|$GIT_ROOT||")

  # Debugging output: Check if coverage file exists after tests
  echo "Checking if ${COVERAGE_FILE} exists..."
  if [ ! -f "${COVERAGE_FILE}" ]; then
    echo "Error: file ${COVERAGE_FILE} not found!"
    exit 1
  fi

  echo "Contents of ${COVERAGE_FILE} before changes:"
  head -n 10 "${COVERAGE_FILE}"

  # Update the file paths in the coverage file
  sed "s|SF:|SF:${PROJECT_ROOT}/|g" "${COVERAGE_FILE}" > "${TEMP_FILE}"
  mv "${TEMP_FILE}" "${COVERAGE_FILE}"

  echo "Contents of ${COVERAGE_FILE} after changes:"
  head -n 10 "${COVERAGE_FILE}"

  echo "Success for ${COVERAGE_FILE}."
fi
