#!/usr/bin/env bash
set -euo pipefail

# netbird's %post scriptlet tries to start the service during install,
# which fails in a container build (no systemd). Skip scriptlets here.
dnf install -y --setopt=tsflags=noscripts netbird

# The skipped %post runs `netbird service install` to write the systemd unit
# file. Call it manually; daemon-reload will fail (no systemd bus in container)
# but the unit file is written before that, so we swallow the error.
netbird service install || true
