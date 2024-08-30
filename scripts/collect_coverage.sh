#!/bin/bash

if [ ! -f dart_test.yaml ]; then
  if grep -q 'flutter:' pubspec.yaml; then
    very_good test --coverage --exclude-tags=golden
  else
    dart pub global run coverage:test_with_coverage
  fi

  dart pub global run remove_from_coverage:remove_from_coverage -f coverage/lcov.info -r '.g.dart$' -r '.gr.dart$' -r '.freezed.dart$' -r '.i69n.dart$' -r 'di_initializer.config.dart'

  COVERAGE_FILE="coverage/lcov.info"
  TEMP_FILE=$(mktemp)
  ROOT=$(pwd)
  GIT_ROOT=$(git rev-parse --show-toplevel)
  PROJECT_ROOT=$(echo "$ROOT" | sed "s|$GIT_ROOT||")
  PROJECT_ROOT="${PROJECT_ROOT#/}"

  if [ ! -f "${COVERAGE_FILE}" ]; then
    echo "Error: file ${COVERAGE_FILE} not found!"
    exit 1
  fi

  sed "s|SF:|SF:${PROJECT_ROOT}/|g" "${COVERAGE_FILE}" > "${TEMP_FILE}"
  mv "${TEMP_FILE}" "${COVERAGE_FILE}"

  echo "Success for ${COVERAGE_FILE}."
fi
