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
    rev = "439aacd3fd0e1194cd46106f9fac606fe302702b";
    hash = "sha256-LrQMpW9V8qg7dJQg+1RVkQq/NRfxaxIYr+MhmS+7OFg=";
  };

  npmDepsHash = "sha256-zzAVIJfSjV/ij0tOlKSWSbPkIQEPrCLwGHAW7/aUyXI=";
  npmFlags = [ "--legacy-peer-deps" ];
  NODE_OPTIONS = "--openssl-legacy-provider";

  postPatch = ''
    cp ${./package-lock.patch} package-lock.json
    # Avoid npm install since it is handled by buildNpmPackage
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
