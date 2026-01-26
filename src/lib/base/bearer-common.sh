#!/usr/bin/env sh
set -u

bearer_common() {
  # Removing trailing space (sed command) is needed here in case there were no
  # --bearer-args passed, so that ${1} in this case is "scan sast --scanner <...> "
  bearer_args="$(echo "${1}" | sed 's/ *$//') --skip-path **/${CONFIG_CACHE_ROOT_DIR_NAME}"

  bearer_path=$(install)
  bearer_version=$(${bearer_path} --version | awk '{print $3}' | sed 's/,//')
  fabasoad_log "info" "Bearer path: ${bearer_path}"
  fabasoad_log "info" "Bearer version: ${bearer_version}"
  fabasoad_log "info" "Bearer arguments: ${bearer_args}"

  fabasoad_log "debug" "Run Bearer scanning:"
  set +e
  ${bearer_path} ${bearer_args}
  bearer_exit_code=$?
  set -e
  fabasoad_log "debug" "Bearer scanning completed"
  msg="Bearer exit code: ${bearer_exit_code}"
  if [ "${bearer_exit_code}" = "0" ]; then
    fabasoad_log "info" "${msg}"
  else
    fabasoad_log "error" "${msg}"
  fi

  uninstall
  exit ${bearer_exit_code}
}
