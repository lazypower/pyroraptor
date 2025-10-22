#!/bin/bash

set -ouex pipefail

### Install packages

# Enable COPR repositories for the more exotic tools
# that aren't in distro
COPR_REPOS=(
  scottames/ghostty
)

for repo in "${COPR_REPOS[@]}"; do
  dnf5 -y copr enable "$repo"
done

dnf5 -y install \
  firefox \
  ghostty

# OnePassword in base for integrations
/ctx/onepassword.sh

# Disable COPRs so they don't end up enabled on the final image:
for repo in "${COPR_REPOS[@]}"; do
  dnf5 -y copr disable "$repo"
done
