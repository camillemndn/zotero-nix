{ buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "zotero-pdf-worker-pdfjs";
  version = builtins.substring 0 9 src.rev;

  src = fetchFromGitHub {
    owner = "zotero";
    repo = "pdf.js";
    rev = "130200b962f0251dc9cf33c2d534873cbbcb1322";
    hash = "sha256-JjsWoA/mvYTqTAW1PzoV/WYxJYoWv557bqfRyhJlO54=";
  };

  npmDepsHash = "sha256-+LTfiFIZoGO/6dY4COEcjAcNcRkwEy+TqwISlUIcwh8=";
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
