#!/bin/bash

set -ouex pipefail

### Install packages

# OnePassword in base for integrations
# TODO: Clean this up - I'm not crazy about splatting in vendor directions.
# and the flatpak is lame due to sandboxing - it works, but not fully.
mkdir -p /var/opt/1Password
rpm --import https://downloads.1password.com/linux/keys/1password.asc
sh -c 'echo -e "[1password]\nname=1Password Stable Channel\nbaseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=\"https://downloads.1password.com/linux/keys/1password.asc\"" > /etc/yum.repos.d/1password.repo'
dnf -y install 1password

# Enable COPR repositories for the more exotic tools
# that aren't in distro
COPR_REPOS=(
  solopasha/hyprland
  errornointernet/walker
  erikreider/SwayNotificationCenter
)

for repo in "${COPR_REPOS[@]}"; do
  dnf5 -y copr enable "$repo"
done

dnf5 -y install \
  1password \
  blueman-applet \
  cliphist \
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
  xdg-desktop-portal-hyprland
  
# Disable COPRs so they don't end up enabled on the final image:
for repo in "${COPR_REPOS[@]}"; do
  dnf5 -y copr disable "$repo"
  rm -rf /etc/yum.repos.d/1password.repo
done

#### Example for enabling a System Unit File
systemctl enable podman.socket
