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

# Add albert app launcher
dnf5 config-manager addrepo --from-repofile=/ctx/albert.repo

# Enable COPR repositories for the more exotic tools
# that aren't in distro
COPR_REPOS=(
  solopasha/hyprland
  errornointernet/walker
  wiiznokes/gauntlet
)

for repo in "${COPR_REPOS[@]}"; do
  dnf5 -y copr enable "$repo"
done

dnf5 -y install \
  albert \
  gauntlet \
	hyprland \
	xdg-desktop-portal-hyprland \
	hyprland-contrib \
	hyprland-plugins \
	hyprpaper \
	hyprpicker \
	hypridle \
	hyprlock \
	hyprsunset \
	hyprpolkitagent \
	hyprsysteminfo \
	hyprland-autoname-workspaces \
	hyprshot \
	satty \
	hyprpanel \
	waybar-git \
	eww-git \
	cliphist \
	nwg-clipman \
	swww \
	waypaper \
	hyprnome \
	hyprdim \
	swaylock-effects \
	pyprland \
	mpvpaper \
	uwsm \
  walker

# Disable COPRs so they don't end up enabled on the final image:
for repo in "${COPR_REPOS[@]}"; do
  dnf5 -y copr disable "$repo"
done

#### Example for enabling a System Unit File
systemctl enable podman.socket
