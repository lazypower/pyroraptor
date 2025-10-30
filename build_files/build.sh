#!/bin/bash

set -ouex pipefail

### Install packages

# Enable COPR repositories for the more exotic tools
# that aren't in distro
COPR_REPOS=(
  solopasha/hyprland
  errornointernet/walker
  erikreider/SwayNotificationCenter
  scottames/ghostty
)

for repo in "${COPR_REPOS[@]}"; do
  dnf5 -y copr enable "$repo"
done

dnf5 -y install \
  cliphist \
  firefox \
  ghostty \
  hyprdim \
  hypridle \
  hyprland \
  hyprland-autoname-workspaces \
  hyprland-contrib \
  hyprland-plugins \
  hyprlock \
  hyprnome \
  hyprpanel \
  hyprpaper \
  hyprpicker \
  hyprpolkitagent \
  hyprshot \
  hyprsunset \
  hyprsysteminfo \
  mpvpaper \
  nwg-clipman \
  pyprland \
  satty \
  swaylock-effects \
  SwayNotificationCenter \
  swww \
  uwsm \
  walker \
  waybar-git \
  waypaper \
  wlogout \
  xdg-desktop-portal-hyprland

# OnePassword in base for integrations
/ctx/onepassword.sh

# Experiment with nix
mkdir -p /nix
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix -o /nix/determinate-nix-installer.sh
chmod a+rx /nix/determinate-nix-installer.sh

# Disable COPRs so they don't end up enabled on the final image:
for repo in "${COPR_REPOS[@]}"; do
  dnf5 -y copr disable "$repo"
done
