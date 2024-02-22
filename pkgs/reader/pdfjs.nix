{ buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "zotero-reader-pdfjs";
  version = builtins.substring 0 9 src.rev;

  src = fetchFromGitHub {
    owner = "zotero";
    repo = "pdf.js";
    rev = "000a5dfad672faaf98a52f06f1e741d3924940f6";
    hash = "sha256-05nAsWY9545pIyhwdX+y+iPpY4Fv7qNQBoVqDlOu3pY=";
  };

  npmDepsHash = "sha256-+LTfiFIZoGO/6dY4COEcjAcNcRkwEy+TqwISlUIcwh8=";
  makeCacheWritable = true;

  # Add a version number
  postPatch = ''
    sed -i package*.json -e '/"name": "pdf.js"/a "version": "1.0.0",'
  '';

  buildPhase = ''
    node_modules/.bin/gulp generic-legacy
  '';

  postInstall = ''
    cp -r build $out/lib/node_modules/pdf.js/build
  '';
}
