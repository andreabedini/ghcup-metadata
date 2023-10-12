#!/usr/bin/env bash
set -x
set -eo pipefail

. .github/workflows/common.sh

export GHCUP_INSTALL_BASE_PREFIX=$RUNNER_TEMP/foobarbaz

curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh

source "$GHCUP_INSTALL_BASE_PREFIX"/.ghcup/env || source "$HOME/.bashrc"

ghcup --version
which ghcup | grep foobarbaz

ghcup_fun() {
	ghcup --url-source="file:$METADATA_FILE" "$@"
}

case $TOOL in
	ghcup)
		ghcup_fun upgrade --force
		;;
    cabal)
        ghcup_fun install "$TOOL" --set "$VERSION"
        ghc_ver="$(ghcup_fun list -t ghc -r -c available | tail -1 | awk '{ print $2 }')"
		ghcup_fun install ghc --set "$ghc_ver"
        ;;
	*)
        ghcup_fun install "$TOOL" --set "$VERSION"
		;;
esac

