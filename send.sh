#!/usr/bin/env bash
set -o errexit -o nounset -o pipefail
IFS=$'\n\t\v'

scp -rP666 nixos jura@192.168.42.152:/tmp
ssh -tp666 jura@192.168.42.152 sudo rsync --recursive --checksum --links --delete --exclude=/hardware-configuration.nix /tmp/nixos/ /etc/nixos/
ssh -tp666 jura@192.168.42.152 sudo /etc/nixos/build.sh
ssh -tp666 jura@192.168.42.152 sudo nixos-rebuild switch
# ssh -p666 -o "IdentitiesOnly=yes" -i ci_key_ed25519 cicd@192.168.42.152 rebuild local /tmp/nixos
