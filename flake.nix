{
  description = "Zotero on Nix";

  outputs = { self, nixpkgs }: {

    packages.x86_64-linux.zotero = nixpkgs.legacyPackages.x86_64-linux.callPackage ./pkgs { };

    packages.aarch64-linux.zotero = self.packages.x86_64-linux.callPackage ./pkgs { };

  };
}
