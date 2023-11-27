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
    rev = "85d3c0ed13f128400e7e54243eacebf349b88fc5";
    hash = "sha256-4Y99bmrHJOsyCDHAxC6ZUP6XfBQ76a1UAOvO4t/d0K8=";
  };

  npmDepsHash = "sha256-nqKXFcB1Y3+S+6IrxNIeKj/VH0V7myavQs+S25GT16w=";
  npmFlags = [ "--legacy-peer-deps" ];
  NODE_OPTIONS = "--openssl-legacy-provider";

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
