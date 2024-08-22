# Zotero on Nix

This is a best effort to package Zotero to [Nixpkgs](https://github.com/NixOS/nixpkgs/) from the [source code](https://github.com/zotero/zotero/).

Zotero officially runs on `x86_64-linux`, though this project makes it available for `aarch64-linux`.

## Disclaimer

Zotero 7 is based on Firefox ESR 115, which will be deprecated in [September 2024](https://whattrainisitnow.com/calendar/).

## How to use

### To launch Zotero

```shell
nix run github:camillemndn/zotero-nix
```

### To use Zotero in a flake

```nix
{
  inputs.zotero-nix.url = "github:camillemndn/zotero-nix";

  outputs = { self, nixpkgs, zotero-nix }:
    let system = "x86_64-linux"; # Change this to "aarch64-linux" for ARM64 support
    in {

      nixosConfigurations.myhost = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          {
            environment.systemPackages = [ zotero-nix.packages.${system}.default ];

            # The rest of the configuration goes here
          }
        ];
      };

    };
}
```

### Update instructions

Use:

```shell
git clone https://github.com/zotero/zotero $zotero_repo_path
./update.sh $zotero_repo_path submodules
```
