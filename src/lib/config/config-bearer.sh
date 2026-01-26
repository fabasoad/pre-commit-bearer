#!/usr/bin/env sh

apply_bearer_config() {
  bearer_version="${1:-${PRE_COMMIT_BEARER_BEARER_VERSION:-${CONFIG_BEARER_VERSION_DEFAULT_VAL}}}"
  if [ "${bearer_version}" != "latest" ]; then
    validate_semver "${bearer_version}" "${CONFIG_BEARER_VERSION_ARG_NAME}"
  fi
  export PRE_COMMIT_BEARER_BEARER_VERSION="${bearer_version}"
}
