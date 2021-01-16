#!/usr/bin/env bash

set -euo pipefail

NIXPKGS_PIN="nixpkgs-plugin-2"
PATCHDIR_RELATIVE="../../nixpkgs-patch"

echo
echo "Setting up a new nixpkgs patch directory for generating a new nixops bundle patch..."
echo

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
BASEPATCH_RELATIVE="$(find "${SCRIPTDIR}"/../patches/nixpkgs-pr83548-20* | sort -n -r | head -n 1)"
BASEPATCH="$(realpath "$BASEPATCH_RELATIVE")"
REPO_ROOT="$(git rev-parse --show-toplevel)"
PATCHDIR=$(realpath "${SCRIPTDIR}/${PATCHDIR_RELATIVE}")
NIXPKGS=$(nix eval --raw --impure --expr "(builtins.getFlake (toString $REPO_ROOT)).inputs.${NIXPKGS_PIN}.outPath")
GITREV=$(nix eval --raw --impure --expr "(builtins.getFlake (toString $REPO_ROOT)).inputs.${NIXPKGS_PIN}.rev")

[ -d "$PATCHDIR" ] && { echo "ERROR: \"$PATCHDIR\" already exists, aborting"; exit 1; }

echo "Copying \"${NIXPKGS_PIN}\" (${NIXPKGS}) to \"${PATCHDIR}\""
mkdir -p "$PATCHDIR"
cp -R "${NIXPKGS}"/* "$PATCHDIR"
chmod -R +w "$PATCHDIR"
cd "$PATCHDIR"

echo
echo "Initializing a git repo to track patch changes"
git init

echo
echo "Making an initial commit at git revision ${GITREV}"
git add -A
git config commit.gpgsign false
git commit --quiet -m 'Initial commit'

echo
echo "Applying and git adding the latest available base patch \"${BASEPATCH}\""
git apply "${BASEPATCH}"
git add -A

echo
echo "The directory \"${PATCHDIR}\" is now ready for patch file generation"
echo
