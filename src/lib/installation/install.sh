#!/usr/bin/env sh

install() {
  fabasoad_log "debug" "Verifying Bearer installation"
  if command -v bearer &> /dev/null; then
    bearer_path="$(which bearer)"
    fabasoad_log "debug" "Bearer is found at ${bearer_path}. Installation skipped"
  else
    if [ -f "${CONFIG_CACHE_APP_BIN_DIR}" ]; then
      err_msg="${CONFIG_CACHE_APP_BIN_DIR} existing file prevents from creating"
      err_msg="${err_msg} a cache directory with the same name. Please either"
      err_msg="${err_msg} remove this file or install bearer globally manually."
      fabasoad_log "error" "${err_msg}"
      exit 1
    fi
    bearer_path="${CONFIG_CACHE_APP_BIN_DIR}/bearer"
    mkdir -p "${CONFIG_CACHE_APP_BIN_DIR}"
    if [ -f "${bearer_path}" ]; then
      fabasoad_log "debug" "Bearer is found at ${bearer_path}. Installation skipped"
    else
      fabasoad_log "debug" "Bearer is not found. Downloading ${PRE_COMMIT_BEARER_BEARER_VERSION} version:"
      if [ "${PRE_COMMIT_BEARER_BEARER_VERSION}" = "latest" ]; then
        curl -sfL "https://raw.githubusercontent.com/${_UPSTREAM_FULL_REPO_NAME}/main/contrib/install.sh" | sh -s -- -b "${CONFIG_CACHE_APP_BIN_DIR}" >&2
      else
        curl -sfL "https://raw.githubusercontent.com/${_UPSTREAM_FULL_REPO_NAME}/main/contrib/install.sh" | sh -s -- -b "${CONFIG_CACHE_APP_BIN_DIR}" "v${PRE_COMMIT_BEARER_BEARER_VERSION}" >&2
      fi
      fabasoad_log "debug" "Downloading completed"
    fi
  fi
  echo "${bearer_path}"
}
