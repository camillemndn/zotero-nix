{
  buildNpmPackage,
  fetchFromGitHub,
  callPackage,
}:

buildNpmPackage rec {
  pname = "zotero-reader";
  version = "7.0.11";

  src = fetchFromGitHub {
    owner = "zotero";
    repo = "zotero";
    rev = version;
    hash = "sha256-eTlysgISTjimKvVhTbnr4Dj4gcN7qAVXAjuUmVqrVlE=";
    fetchSubmodules = true;
  };

  sourceRoot = "source/reader";

  npmDepsHash = "sha256-zOcXOio2VLzElHf5LtJO4XcBDLV5WGgYAeRjFrbUsNE=";
  npmRebuildFlags = [ "--ignore-scripts" ];

  # Avoid npm install since it is handled by buildNpmPackage
  postPatch = ''
    rm -r epubjs/epub.js
    rm -r pdfjs/pdf.js

    sed -i pdfjs/build \
      -e 's/npx gulp/#npx gulp/g' \
      -e 's/npm ci/#npm ci/g'
  '';

  dontNpmBuild = true;

  # This makes webpack available for later build
  preInstall = ''
    mkdir -p $out/lib/node_modules/pdf-reader
    cp -r node_modules $out/lib/node_modules/pdf-reader/node_modules
  '';

  postInstall = ''
    rm -r $out/lib/node_modules/pdf-reader/epubjs/epub.js
    cp -Lr ${callPackage ./epubjs.nix { }}/lib/node_modules/epubjs $out/lib/node_modules/pdf-reader/epubjs/epub.js
    cp -Lr ${callPackage ./pdfjs.nix { }}/lib/node_modules/pdf.js $out/lib/node_modules/pdf-reader/pdfjs/pdf.js
  '';
}
