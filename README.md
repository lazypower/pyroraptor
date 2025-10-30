# Cobalt Rush

An OCI image for my workstations, built from a bluefin-dx base.

## Overview

This repository hosts my custom bootc image that serves as the foundation
for my workstation setups. It's a derivative of bluefin-dx that layers Nix,
firefox, 1password  and Hyprblue, creating a unified development environment.

## Installation

```bash
bootc switch ghcr.io/lazypower/cobaltrush:latest
```

## Verification

Verify the image with cosign:

```bash
cosign verify ghcr.io/lazypower/cobaltrush:latest
```

You may notice a gitea directory - my upstream is a private repository.
Stable updates are pushed to github as a backup source of builds or for
folks to adopt at their own peril.

## What you'll find in here

Some basic utilities as a foundation installed via dnf:

- firefox
- ghostty
- 1password

Alternative Desktop Environments:

- hyprland
- supporting tools

Experimental:

- Nix

I've been dabbling with devbox as an alternative to raw containers for local
tooling alongside brew. This may or may not survive moving forward depending
on behavior. upstream removed nix support due to issues.
