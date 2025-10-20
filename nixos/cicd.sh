#!/usr/bin/env bash
set -o errexit -o nounset -o pipefail
IFS=$'\n\t\v'

if ! grep VENDOR_NAME=NixOS /etc/os-release >/dev/null; then
    2>&1 echo "this ain't nixos"
    exit 1
fi

INPUT=${SSH_ORIGINAL_COMMAND:-${@:-}}

# echo "run: $INPUT"
echo "$INPUT" > /tmp/last-cicd-cmd

case "$INPUT" in
    *"libexec/sftp-server")
        
    "scp -t /home/cicd")
        exec /usr/bin/scp -t /home/cicd
        ;;
    # "rebuild local "*)
    #     LOCAL_PATH=${INPUT#*"rebuild local "}
    #     LOCAL_PATH=$(echo "${LOCAL_PATH}" | sed -E 's|^([a-zA-Z0-9_\-\/]*).*|\1|')
    #     if [[ -z "${LOCAL_PATH}" ]]; then
    #         2>&1 "no path given"
    #         exit 1
    #     fi
        
    #     if [[ $LOCAL_PATH != */ ]]; then
    #         LOCAL_PATH="${LOCAL_PATH}/"
    #     fi
    #     echo "local build from ${LOCAL_PATH}"
    #     sudo rsync --recursive --checksum --links --delete --exclude=/hardware-configuration.nix "${LOCAL_PATH}" /etc/nixos/
    #     sudo nixos-rebuild switch
    #     exit 0
    #     ;;
    # "rebuild git "*)
    #     echo 
    #     if [[ ! -d /tmp/nixos_git ]]; then
    #         git clone https://github.com/Juravenator/nixos-comin-test.git /tmp/nixos_git
    #     fi
    #     git fetch --all
    #     git workspace
    #     echo git build
    #     ;;
    *)
        echo "Access denied"
        exit 1
        ;;
esac

