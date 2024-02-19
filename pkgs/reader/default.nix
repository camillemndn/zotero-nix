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
    rev = "39e92a143d23ff874789ccf360c4633939cc2784";
    hash = "sha256-uidg5VnPvopH6puPWaJ0biV4V1z5Hw4gwelQmwB7uNg=";
  };

  npmDepsHash = "sha256-cgX9m8csmsRt3+HavW5VqDypskCXM4LC8acOFe4adkY=";
  npmRebuildFlags = [ "--ignore-scripts" ];

  postPatch = ''
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
