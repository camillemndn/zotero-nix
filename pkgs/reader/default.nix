{ buildNpmPackage
, fetchFromGitHub
, callPackage
}:

buildNpmPackage rec {
  pname = "zotero-reader";
  version = builtins.substring 0 9 src.rev;

  src = fetchFromGitHub {
    owner = "zotero";
    repo = "pdf-reader";
    rev = "565b1224775f12ccc3d89770cff4b158f1b5d89a";
    hash = "sha256-UJLbVoJej5zmyznTdOqusgPaR9IGDcvBIiRJ8ZYzK9U=";
  };

  npmDepsHash = "sha256-26i2+sY2Kp0DIFOUkQVlI67HO4KTcQyd8pqSZqpWCCQ=";
  npmRebuildFlags = [ "--ignore-scripts" ];

  # Avoid npm install since it is handled by buildNpmPackage
  postPatch = ''
    sed -i pdfjs/build \
      -e 's/npx gulp/#npx gulp/g' \
      -e 's/npm ci/#npm ci/g'
  '';

  buildPhase = ''
    rm -rf pdf.js
    cp -Lr ${callPackage ./pdfjs.nix {}}/lib/node_modules/pdf.js pdfjs
  '';

  preInstall = ''
    mkdir -p $out/lib/node_modules/pdf-reader
    cp -r node_modules $out/lib/node_modules/pdf-reader/node_modules
  '';
}
