{ buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "zotero-reader-pdfjs";
  version = builtins.substring 0 9 src.rev;

  src = fetchFromGitHub {
    owner = "zotero";
    repo = "pdf.js";
    rev = "10691ef026c3a3e56ba5afb29ff9f89412bd0698";
    hash = "sha256-1lgS0hoeJ27k7RnDUloCBY635IudF3VYvgc5i8y31yA=";
  };

  npmDepsHash = "sha256-+LTfiFIZoGO/6dY4COEcjAcNcRkwEy+TqwISlUIcwh8=";
  npmFlags = [ "--legacy-peer-deps" ];
  NODE_OPTIONS = "--openssl-legacy-provider";
  makeCacheWritable = true;

  postPatch = ''
    # Add a version number
    sed -i package*.json -e '/"name": "pdf.js"/a "version": "1.0.0",'
  '';

  buildPhase = ''
    node_modules/.bin/gulp generic-legacy
  '';

  postInstall = ''
    cp -r build $out/lib/node_modules/pdf.js/build
  '';
}
