#!/bin/bash

set -ouex pipefail

### Uninstall some packages from base

# I dont use vscode so nix it.
dnf remove -y code

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
  ghostty \
  vulkan-headers \
  vulkan-loader-devel \
  glslang \
  spirv-tools \
  glslang-devel \
  spirv-tools-devel \
  vulkan-tools
# Vulkan dev for llama.cpp

# OnePassword in base for integrations
/ctx/onepassword.sh

# Experiment with nix
mkdir -p /nix
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix -o /nix/determinate-nix-installer.sh
chmod a+rx /nix/determinate-nix-installer.sh

# Disable GDM suspend on the login screen
mkdir -p /etc/dconf/db/gdm.d
cat > /etc/dconf/db/gdm.d/disable-sleep <<'DCONF'
[org/gnome/settings-daemon/plugins/power]
sleep-inactive-ac-timeout=0
sleep-inactive-ac-type='nothing'
DCONF
dconf update

# Disable COPRs so they don't end up enabled on the final image:
for repo in "${COPR_REPOS[@]}"; do
  dnf5 -y copr disable "$repo"
done
