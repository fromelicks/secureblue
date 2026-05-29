#!/usr/bin/env bash
set -euo pipefail

# netbird's %post scriptlet tries to start the service during install,
# which fails in a container build (no systemd). Skip scriptlets here;
# the systemd module enables netbird.service in the image.
dnf install -y --setopt=tsflags=noscripts netbird
