{
  buildNpmPackage,
  fetchFromGitHub,
  callPackage,
}:

buildNpmPackage rec {
  pname = "zotero-reader";
  version = "7.0.1";

  src = fetchFromGitHub {
    owner = "zotero";
    repo = "zotero";
    rev = version;
    hash = "sha256-VLl7vuk7x1DEBKFiRBHTLsYxKHoC2aah9P+rhQx6AbQ=";
    fetchSubmodules = true;
  };

  sourceRoot = "source/reader";

  npmDepsHash = "sha256-26i2+sY2Kp0DIFOUkQVlI67HO4KTcQyd8pqSZqpWCCQ=";
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
