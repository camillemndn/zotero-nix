{
  description = "Zotero on Nix";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";
    flake-compat.url = "github:edolstra/flake-compat";
    utils.url = "flake-utils";
  };

  outputs =
    { nixpkgs, utils, ... }:

    utils.lib.eachSystem
      [
        "x86_64-linux"
        "aarch64-linux"
      ]
      (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        rec {
          packages = rec {
            default = zotero;
            zotero = pkgs.wrapFirefox zotero-unwrapped { };
            zotero-unwrapped = pkgs.callPackage ./pkgs { };
            zotero-note-editor = pkgs.callPackage ./pkgs/note-editor.nix { };
            zotero-pdf-worker = pkgs.callPackage ./pkgs/pdf-worker { };
            zotero-pdf-worker-pdfjs = pkgs.callPackage ./pkgs/pdf-worker/pdfjs.nix { };
            zotero-reader = pkgs.callPackage ./pkgs/reader { };
            zotero-reader-epubjs = pkgs.callPackage ./pkgs/reader/epubjs.nix { };
            zotero-reader-pdfjs = pkgs.callPackage ./pkgs/reader/pdfjs.nix { };
            zotero-single-file = pkgs.callPackage ./pkgs/single-file.nix { };
            zotero-translators = pkgs.callPackage ./pkgs/translators.nix { };
            zotero-xpcom-utilities = pkgs.callPackage ./pkgs/xpcom-utilities.nix { };
          };

          checks = packages;
        }
      );
}
