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
    rev = "ff5b1568ed27c25c2b0d3939a831f09177f98e9d";
    hash = "sha256-q+CqY7rk+FQR/NUgJ+rJ25oJ9eloaucvyfC+ZzxJ/eY=";
  };

  npmDepsHash = "sha256-cgX9m8csmsRt3+HavW5VqDypskCXM4LC8acOFe4adkY=";
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
