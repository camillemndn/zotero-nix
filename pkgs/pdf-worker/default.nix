{
  buildNpmPackage,
  fetchFromGitHub,
  callPackage,
}:

buildNpmPackage rec {
  pname = "zotero-pdf-worker";
  version = "7.0.1";

  src = fetchFromGitHub {
    owner = "zotero";
    repo = "zotero";
    rev = version;
    hash = "sha256-VLl7vuk7x1DEBKFiRBHTLsYxKHoC2aah9P+rhQx6AbQ=";
    fetchSubmodules = true;
  };

  sourceRoot = "source/pdf-worker";

  npmDepsHash = "sha256-TGuN1fZOClzm6xD2rmn5BAemN4mbyOVaLbSRyMeDIm8=";

  # Avoid npm install since it is handled by buildNpmPackage
  postPatch = ''
    sed -i scripts/build-pdfjs \
      -e 's/npx gulp/#npx gulp/g' \
      -e 's/npm ci/#npm ci/g'
  '';

  buildPhase = ''
    rm -rf pdf.js
    cp -Lr ${callPackage ./pdfjs.nix { }}/lib/node_modules/pdf.js pdf.js
  '';

  preInstall = ''
    mkdir -p $out/lib/node_modules/pdf-worker
    cp -r node_modules $out/lib/node_modules/pdf-worker/node_modules
  '';
}
