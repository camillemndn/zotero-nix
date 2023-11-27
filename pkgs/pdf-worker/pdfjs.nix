{ buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "zotero-pdf-worker-pdfjs";
  version = builtins.substring 0 9 src.rev;

  src = fetchFromGitHub {
    owner = "zotero";
    repo = "pdf.js";
    rev = "159a1d5612b803ca1d8b1f5d7498d5e84a58c284";
    hash = "sha256-oERIuPro56yQADDgTuNVBYhdafXurZ+3br0tiB3+luE=";
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
    node_modules/.bin/gulp lib
  '';

  postInstall = ''
    cp -r build $out/lib/node_modules/pdf.js/build
  '';
}
