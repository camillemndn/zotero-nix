# Zotero on Nix

This is a best effort to package Zotero to [Nixpkgs](https://github.com/NixOS/nixpkgs/) from the [source code](https://github.com/zotero/zotero/).

Zotero officially runs on ```x86_64-linux```, though this project makes it available for ```aarch64-linux```.

## Disclaimer

Since Zotero is based on Firefox, whose cycles are shorter than Zotero's, the current version of Zotero 7, which is still in beta, is based on Firefox 102, which is already [*deprecated*](https://whattrainisitnow.com/calendar/).

This is still better than Zotero 6, currently available in Nixpkgs, which is based on Firefox 60, which is deprecated since September 2019.

*As of March 2024*, a new branch [```fx115```](https://github.com/camillemndn/zotero-nix/tree/fx115) is available, based on Firefox 115 ESR, which will be supported until September 2024.

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

