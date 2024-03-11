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
    rev = "5cdb1550bf16693380854ef0984fd66efe3f982c";
    hash = "sha256-51osZ4tUhR0UDsLsn+k23Zc45Vznym7XF3H2He8y/N4=";
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
