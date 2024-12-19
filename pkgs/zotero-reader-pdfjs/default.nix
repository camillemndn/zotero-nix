{
  buildNpmPackage,
  fetchFromGitHub,
  writeScriptBin,
}:

buildNpmPackage rec {
  pname = "zotero-reader-pdfjs";
  version = "7.0.11";

  src = fetchFromGitHub {
    owner = "zotero";
    repo = "zotero";
    rev = version;
    hash = "sha256-eTlysgISTjimKvVhTbnr4Dj4gcN7qAVXAjuUmVqrVlE=";
    fetchSubmodules = true;
  };

  sourceRoot = "source/reader/pdfjs/pdf.js";

  npmDepsHash = "sha256-3a0lNwUxlHOnANq7MyefFCxDkc7PbWfXhUY6lf8U2Pc=";
  makeCacheWritable = true;

  nativeBuildInputs = [
    (writeScriptBin "prebuild" ''
      echo "Skip prebuild step."
    '')
  ];

  # Add a version number
  postPatch = ''
    sed -i package*.json -e '/"name": "pdf.js"/a "version": "1.0.0",'
  '';

  buildPhase = ''
    node_modules/.bin/gulp generic-legacy
    node_modules/.bin/gulp minified-legacy
  '';

  postInstall = ''
    cp -r build $out/lib/node_modules/pdf.js/build
  '';
}
