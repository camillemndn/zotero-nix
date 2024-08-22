#! /usr/bin/env nix-shell
#! nix-shell -i bash -p git

# Check if the path argument is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <zotero_repo_path>"
    exit 1
fi

# Assign the first argument as the path to the Zotero Git repository
export ZOTERO_REPO_PATH=$1

cd "$ZOTERO_REPO_PATH"
git submodule foreach --recursive --quiet 'if [ -f "package.json" ]; then echo $(realpath --relative-to="$ZOTERO_REPO_PATH" "$toplevel/$path"); fi'
