#! /usr/bin/env nix-shell
#! nix-shell -i bash -p bash git nix-update

# Check if the path argument is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <zotero_repo_path> <name_mapping_file>"
    exit 1
fi

# Store the current directory
SCRIPT_DIR=$(pwd)

# Assign the first argument as the path to the Zotero Git repository
ZOTERO_REPO_PATH=$1

# Assign the second argument as the name mapping file
NAME_MAPPING_FILE=$2

# Change directory to the Zotero Git repository
pushd $ZOTERO_REPO_PATH || { echo "Failed to change directory to $ZOTERO_REPO_PATH"; exit 1; }

# Pulls the latest version
git pull
git checkout main

# Update submodules recursively
git submodule update --init --recursive
      
sha1=$(git rev-parse HEAD)
popd

echo "Updating zotero with hash: $sha1"
echo $PWD
nix-update --flake --version "branch=$sha1" zotero-unwrapped 

# Execute a command for each submodule with a package.json file
while IFS= read -r line; do
    submodule_path=$(echo "$line" | cut -d' ' -f1)
    submodule_name=$(echo "$line" | cut -d' ' -f2)
    
    pushd $ZOTERO_REPO_PATH/$submodule_path
    sha1=$(git rev-parse HEAD)
    popd
    
    echo "Updating submodule '$submodule_name' with hash: $sha1"
    echo $PWD
    nix-update --flake --version "branch=$sha1" "$submodule_name"
done < "$NAME_MAPPING_FILE"
