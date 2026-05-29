#!/usr/bin/env bash
set -euo pipefail

UUID="paperwm@paperwm.github.com"
DESTDIR="/usr/share/gnome-shell/extensions/${UUID}"
TMP=$(mktemp -d)
trap 'rm -rf "${TMP}"' EXIT

# Fetch the latest release zip URL from GitHub (anonymous API, 60 req/hr limit is fine for CI)
ZIPURL=$(curl -sSf https://api.github.com/repos/paperwm/PaperWM/releases/latest \
  | python3 -c "
import sys, json
data = json.load(sys.stdin)
for asset in data['assets']:
    if asset['name'].endswith('.zip'):
        print(asset['browser_download_url'])
        break
")

if [[ -z "${ZIPURL}" ]]; then
    echo "ERROR: could not find PaperWM zip in latest release assets" >&2
    exit 1
fi

echo "Installing PaperWM from ${ZIPURL}"
curl -sSfL "${ZIPURL}" -o "${TMP}/paperwm.zip"
mkdir -p "${DESTDIR}"
unzip -q "${TMP}/paperwm.zip" -d "${DESTDIR}"

# Compile extension-local schemas so GNOME Shell can load them
if [[ -d "${DESTDIR}/schemas" ]]; then
    glib-compile-schemas "${DESTDIR}/schemas"
fi
