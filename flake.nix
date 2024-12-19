{
  description = "Zotero on Nix";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";
    flake-compat.url = "github:edolstra/flake-compat";
    utils.url = "flake-utils";
  };

  outputs =
    { nixpkgs, utils, ... }:

    utils.lib.eachSystem [ "aarch64-linux" "x86_64-linux" ] (
      system:
      let
        pkgs = import nixpkgs { inherit system; };

        callPackage = pkgs.lib.customisation.callPackageWith (pkgs // ours);

        ours = builtins.listToAttrs (
          builtins.map (path: {
            name = path;
            value = callPackage (./pkgs + "/${path}") { };
          }) (builtins.attrNames (builtins.readDir ./pkgs))
        );
      in
      rec {
        packages = ours // rec {
          default = zotero;
          zotero = pkgs.wrapFirefox ours.zotero-unwrapped { };
        };

        checks = packages;
      }
    );
}
