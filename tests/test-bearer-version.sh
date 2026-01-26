#!/usr/bin/env sh

TESTS_DIR=$(dirname "$(realpath "$0")")
ROOT_DIR=$(dirname "${TESTS_DIR}")
SRC_DIR="${ROOT_DIR}/src"

test_bearer_version_param_precedence() {
  command="${1}"
  bearer_version_cmd="${2}"
  bearer_version_env_var="${3}"
  version_expected="${4}"

  test_name="${FUNCNAME:-${0##*/}}: $@"

  if command -v bearer &> /dev/null; then
    echo "[SKIP] ${test_name} - bearer installed globally"
  else
    output=$(PRE_COMMIT_BEARER_BEARER_VERSION="${bearer_version_env_var}" \
      "${SRC_DIR}/main.sh" "${command}" \
      "--bearer-args=--quiet --hook-args=--log-level=info --bearer-version=${bearer_version_cmd}" \
      2>&1 >/dev/null)

    version_actual=$(echo "${output}" | grep 'Bearer version:' | sed 's/.*Bearer version: \([0-9.]*\).*/\1/')
    if [ "${version_actual}" != "${version_expected}" ]; then
      echo "[FAIL] ${test_name} - Expected: ${version_expected}. Actual: ${version_actual}"
      printf "\n%s" "${output}"
      exit 1
    fi

    echo "[PASS] ${test_name}"
  fi
}

test_bearer_version_env_var() {
  command="${1}"
  bearer_version_env_var="${2}"
  version_expected="${bearer_version_env_var}"

  test_name="${FUNCNAME:-${0##*/}}: $@"

  if command -v bearer &> /dev/null; then
    echo "[SKIP] ${test_name} - bearer installed globally"
  else
    output=$(PRE_COMMIT_BEARER_BEARER_VERSION="${bearer_version_env_var}" \
      "${SRC_DIR}/main.sh" "${command}" \
      "--bearer-args=--quiet --hook-args=--log-level=info" \
      2>&1 >/dev/null)

    version_actual=$(echo "${output}" | grep 'Bearer version:' | sed 's/.*Bearer version: \([0-9.]*\).*/\1/')
    if [ "${version_actual}" != "${version_expected}" ]; then
      echo "[FAIL] ${test_name} - Expected: ${version_expected}. Actual: ${version_actual}"
      printf "\n%s" "${output}"
      exit 1
    fi

    echo "[PASS] ${test_name}"
  fi
}

main() {
  printf "\nTesting %s...\n" "$(basename "$0")"
  test_bearer_version_param_precedence "scan-secrets" "1.51.0" "1.51.1" "1.51.0"
  test_bearer_version_param_precedence "scan-secrets" "1.51.1" "1.51.0" "1.51.1"
  test_bearer_version_env_var "scan-secrets" "1.51.0"
  printf "[PASS] Total 3 tests passed\n"
}

main "$@"
