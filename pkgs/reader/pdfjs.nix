{ buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "zotero-reader-pdfjs";
  version = builtins.substring 0 9 src.rev;

  src = fetchFromGitHub {
    owner = "zotero";
    repo = "pdf.js";
    rev = "b9073e7ed019129f0e5169d21a406025f43eee34";
    hash = "sha256-+GFyWncG540EOSdFTsGqeMeOY22nm3y3Oiau9spzTPs=";
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
