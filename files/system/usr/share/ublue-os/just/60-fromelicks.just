# Rebase to the latest fromelicks custom image and prompt to reboot
[group('Custom')]
update-fromelicks:
    #!/usr/bin/env bash
    set -euo pipefail
    rpm-ostree rebase ostree-image-signed:docker://ghcr.io/fromelicks/secureblue-nvidia-open-hardened:latest
    echo ""
    echo "Rebase queued — run 'systemctl reboot' to apply."
