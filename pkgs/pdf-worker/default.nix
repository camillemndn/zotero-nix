{
  buildNpmPackage,
  fetchFromGitHub,
  callPackage,
}:

buildNpmPackage rec {
  pname = "zotero-pdf-worker";
  version = builtins.substring 0 9 src.rev;

  src = fetchFromGitHub {
    owner = "zotero";
    repo = "pdf-worker";
    rev = "96059e77c1cd7e70418091762abe79875214d4ce";
    hash = "sha256-IUZ9b8SZYH87aO04HaNGDtB2dczpO+4G0GmTGlE1Bd4=";
  };

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
