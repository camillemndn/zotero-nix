{
  description = "Zotero on Nix";

  outputs = { self, nixpkgs }: {

    packages.x86_64-linux = rec {
      default = zotero;
      zotero = nixpkgs.legacyPackages.x86_64-linux.callPackage ./pkgs { };
    };

    packages.aarch64-linux = rec {
      default = zotero;
      zotero = nixpkgs.legacyPackages.aarch64-linux.callPackage ./pkgs { };
    };

  };
}
