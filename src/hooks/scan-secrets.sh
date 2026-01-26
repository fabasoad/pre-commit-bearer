#!/usr/bin/env sh
set -u

scan_secrets() {
  bearer_common "scan . --scanner secrets $@"
}
