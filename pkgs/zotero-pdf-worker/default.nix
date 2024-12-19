{
  buildNpmPackage,
  fetchFromGitHub,
  zotero-pdf-worker-pdfjs,
}:

buildNpmPackage rec {
  pname = "zotero-pdf-worker";
  version = "7.0.11";

  src = fetchFromGitHub {
    owner = "zotero";
    repo = "zotero";
    rev = version;
    hash = "sha256-eTlysgISTjimKvVhTbnr4Dj4gcN7qAVXAjuUmVqrVlE=";
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
