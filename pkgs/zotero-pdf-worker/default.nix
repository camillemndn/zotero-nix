{
  buildNpmPackage,
  fetchFromGitHub,
  zotero-pdf-worker-pdfjs,
}:

buildNpmPackage rec {
  pname = "zotero-pdf-worker";
  version = "fa48e978c7001a3b3b487f738756600e312fe23d";

  src = fetchFromGitHub {
    owner = "zotero";
    repo = "zotero";
    rev = version;
    hash = "sha256-ms7sq5XrvagskTgtXXLtI7W/Q3z/6bo+2v1YSytP5qc=";
    fetchSubmodules = true;
  };

  sourceRoot = "source/pdf-worker";

  npmDepsHash = "sha256-TGuN1fZOClzm6xD2rmn5BAemN4mbyOVaLbSRyMeDIm8=";

  postPatch = ''
    rm -r pdf.js

    sed -i scripts/build-pdfjs \
      -e 's/npx gulp/#npx gulp/g' \
      -e 's/npm ci/#npm ci/g'
  '';

  dontNpmBuild = true;

  # This makes webpack available for later build
  preInstall = ''
    mkdir -p $out/lib/node_modules/pdf-worker
    cp -r node_modules $out/lib/node_modules/pdf-worker/node_modules
  '';

  postInstall = ''
    cp -Lr ${zotero-pdf-worker-pdfjs}/lib/node_modules/pdf.js $out/lib/node_modules/pdf-worker/pdf.js
  '';
}
