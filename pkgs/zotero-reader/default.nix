{
  buildNpmPackage,
  fetchFromGitHub,
  zotero-reader-epubjs,
  zotero-reader-pdfjs,
}:

buildNpmPackage rec {
  pname = "zotero-reader";
  version = "fa48e978c7001a3b3b487f738756600e312fe23d";

  src = fetchFromGitHub {
    owner = "zotero";
    repo = "zotero";
    rev = version;
    hash = "sha256-ms7sq5XrvagskTgtXXLtI7W/Q3z/6bo+2v1YSytP5qc=";
    fetchSubmodules = true;
  };

  sourceRoot = "source/reader";

  npmDepsHash = "sha256-kD3xA3N0gETKnB1nNl0c7Zkh+3zQEcQtsY7cZBdh8KQ=";
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
    cp -Lr ${zotero-reader-epubjs}/lib/node_modules/epubjs $out/lib/node_modules/pdf-reader/epubjs/epub.js
    cp -Lr ${zotero-reader-pdfjs}/lib/node_modules/pdf.js $out/lib/node_modules/pdf-reader/pdfjs/pdf.js
  '';
}
