#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
# dnf5 install -y tmux

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

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
  blueman-applet \
  cliphist \
  eww-git \
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
done

#### Example for enabling a System Unit File
systemctl enable podman.socket
