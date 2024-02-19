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
    rev = "613e4a78f3c2176c339c0583f678c343466cbf76";
    hash = "sha256-Mzlo89S7bCZNNr0DPAznTKfo7VhUsLuPy7gRcYh16oo=";
  };

  npmDepsHash = "sha256-nqKXFcB1Y3+S+6IrxNIeKj/VH0V7myavQs+S25GT16w=";

  postPatch = ''
    # Avoid npm install since it is handled by buildNpmPackage
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
