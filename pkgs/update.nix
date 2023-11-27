{ callPackage }:

{
  zotero-note-editor = callPackage ./note-editor.nix { };
  zotero-pdf-worker = callPackage ./pdf-worker { };
  zotero-pdf-worker-pdfjs = callPackage ./pdf-worker/pdfjs.nix { };
  zotero-reader = callPackage ./reader { };
  zotero-reader-epubjs = callPackage ./reader/epubjs.nix { };
  zotero-reader-pdfjs = callPackage ./reader/pdfjs.nix { };
  zotero-single-file = callPackage ./single-file.nix { };
  zotero-translators = callPackage ./translators.nix { };
  zotero-xpcom-utilities = callPackage ./xpcom-utilities.nix { };
}
