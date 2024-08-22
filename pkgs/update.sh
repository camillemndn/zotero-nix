#! /usr/bin/env nix-shell
#! nix-shell -i bash -p bash git nix-update curl jq

# Set default values for the script arguments
ZOTERO_REPO_PATH=${1:-$(mktemp -d /tmp/zotero.XXX)}
NAME_MAPPING_FILE=${2:-"pkgs/submodules"}
TAG=${3:-$(curl -s https://api.github.com/repos/zotero/zotero/tags | jq -r '.[0].name')}

# Check if the name mapping file exists
if [ ! -f "$NAME_MAPPING_FILE" ]; then
    echo "Name mapping file '$NAME_MAPPING_FILE' not found!"
    exit 1
fi

# Clone the Zotero Git repository using a shallow clone
echo "Cloning Zotero repository into $ZOTERO_REPO_PATH"
git clone --depth 1 --branch "$TAG" --recurse-submodules -c advice.detachedHead=false https://github.com/zotero/zotero.git "$ZOTERO_REPO_PATH"

# Change directory to the Zotero Git repository
pushd "$ZOTERO_REPO_PATH" || { echo "Failed to change directory to $ZOTERO_REPO_PATH"; exit 1; }

# Get the latest commit hash of the TAG
sha1=$(git rev-parse HEAD)
popd || { echo "Failed to exit directory $ZOTERO_REPO_PATH"; exit 1; }

echo "Updating zotero with hash: $sha1"
echo "$PWD"
nix-update --flake --version "$TAG" zotero-unwrapped 

# Execute a command for each submodule with a package.json file
while IFS= read -r line; do
    submodule_path=$(echo "$line" | cut -d' ' -f1)
    submodule_name=$(echo "$line" | cut -d' ' -f2)
    
    pushd "$ZOTERO_REPO_PATH/$submodule_path" || { echo "Failed to change directory to $ZOTERO_REPO_PATH/$submodule_path"; exit 1; }
    sha1=$(git rev-parse HEAD)
    popd || { echo "Failed to exit directory $ZOTERO_REPO_PATH/$submodule_path"; exit 1; }
    
    echo "Updating submodule '$submodule_name' with hash: $sha1"
    echo "$PWD"
    nix-update --flake --version "branch=$sha1" "$submodule_name"
done < "$NAME_MAPPING_FILE"
