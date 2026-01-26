#!/usr/bin/env sh
set -u

scan_sast() {
  bearer_common "scan . --scanner sast $@"
}
