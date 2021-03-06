#!/usr/bin/env bash

set -euo pipefail

DEVDIR_RELATIVE="../../nixops-dev"

echo
echo "Setting up a new nixops-dev directory for local development and testing..."
echo

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
DEVDIR=$(realpath "${SCRIPTDIR}/${DEVDIR_RELATIVE}")

[ -d "$DEVDIR" ] && { echo "ERROR: \"$DEVDIR\" already exists, aborting"; exit 1; }

echo "Making \"${DEVDIR}\" to hold nixops and related repos"
mkdir -p "$DEVDIR"
cd "$DEVDIR"
echo
git clone https://github.com/NixOS/nixops
echo
git clone https://github.com/NixOS/nixops-aws
echo
git clone https://github.com/nix-community/nixops-encrypted-links
echo
git clone https://github.com/nix-community/nixops-gce
echo
git clone https://github.com/NixOS/nixops-hetzner
echo
git clone https://github.com/nix-community/nixops-libvirtd
echo
git clone https://github.com/input-output-hk/nixops-packet
echo
git clone https://github.com/nix-community/nixops-vbox
echo
git clone https://github.com/input-output-hk/nixops-wg-links
echo

echo
echo "The following lines can now replace the corresponding pyproject.toml lines for local development:"
echo
echo "nixops = {path = \"${DEVDIR}/nixops\"}"
echo "nixops-aws = {path = \"${DEVDIR}/nixops-aws\"}"
echo "nixops-encrypted-links = {path = \"${DEVDIR}/nixops-encrypted-links\"}"
echo "nixops-gcp = {path = \"${DEVDIR}/nixops-gce\"}"
echo "nixops-hetzner = {path = \"${DEVDIR}/nixops-hetzner\"}"
echo "nixops-packet = {path = \"${DEVDIR}/nixops-packet\"}"
echo "nixops-virtd = {path = \"${DEVDIR}/nixops-libvirtd\"}"
echo "nixopsvbox = {path = \"${DEVDIR}/nixops-vbox\"}"
echo "nixops-wg-links = {path = \"${DEVDIR}/nixops-wg-links\"}"
echo

echo "The directory \"${DEVDIR}\" is now ready for local development and testing"
echo
