{ buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "zotero-reader-epubjs";
  version = builtins.substring 0 9 src.rev;

  src = fetchFromGitHub {
    owner = "zotero";
    repo = "epub.js";
    rev = "91c1d637d2a18735d7976b3afed040a97d063c8d";
    hash = "sha256-oU06BaZLAMXuGcoCMuizZoTmN3Sb9ad9ppISm28bLE0=";
  };

  npmDepsHash = "sha256-LwpOG2bMdn13CAGgVf0APcj4R4z4PsKzHUwO8dujsYE=";
  npmFlags = [ "--legacy-peer-deps" ];
  NODE_OPTIONS = "--openssl-legacy-provider";
  # makeCacheWritable = true;

  postPatch = ''
    sed -i package.json -e '/karma-phantomjs-launcher/d'
    cp ${./epubjs-package-lock.patch} package-lock.json
  '';
}
