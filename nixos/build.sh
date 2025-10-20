#!/usr/bin/env bash
set -o errexit -o nounset -o pipefail
IFS=$'\n\t\v'
cd `dirname "${BASH_SOURCE[0]:-$0}"`

if ! grep VENDOR_NAME=NixOS /etc/os-release >/dev/null; then
    2>&1 echo "this ain't nixos"
    exit 1
fi

# download any referenced github ssh public keys
for line in $(cat *.nix | grep /etc/nixos/github_ssh_keys); do
    # echo "line: $line"
    username="$(echo "$line" | sed -E 's|.*/github_ssh_keys/([a-z0-9\-]*).*|\1|')"
    echo "Fetching Github SSH public keys for $username"
    # https://github.com/<username>.keys
    curl --silent --fail -Lo "/etc/nixos/github_ssh_keys/${username}" "https://github.com/${username}.keys"
done

# nixos-rebuild switch