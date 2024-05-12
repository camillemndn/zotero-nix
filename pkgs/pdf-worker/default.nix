{ buildNpmPackage
, fetchFromGitHub
, callPackage
}:

buildNpmPackage rec {
  pname = "zotero-pdf-worker";
  version = builtins.substring 0 9 src.rev;

  src = fetchFromGitHub {
    owner = "zotero";
    repo = "pdf-worker";
    rev = "b05d24b9a473a9bc323c1dab01e8bc5aa0581b92";
    hash = "sha256-h1QsFMTN0k/spFUVxe0JZMN+plRvvKa6ef1z9pU9u2U=";
  };

  npmDepsHash = "sha256-nqKXFcB1Y3+S+6IrxNIeKj/VH0V7myavQs+S25GT16w=";

  # Avoid npm install since it is handled by buildNpmPackage
  postPatch = ''
    sed -i scripts/build-pdfjs \
      -e 's/npx gulp/#npx gulp/g' \
      -e 's/npm ci/#npm ci/g'
  '';

  buildPhase = ''
    rm -rf pdf.js
    cp -Lr ${callPackage ./pdfjs.nix {}}/lib/node_modules/pdf.js pdf.js
  '';

  preInstall = ''
    mkdir -p $out/lib/node_modules/pdf-worker
    cp -r node_modules $out/lib/node_modules/pdf-worker/node_modules
  '';
}
