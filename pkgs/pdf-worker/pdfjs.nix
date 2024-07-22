{
  buildNpmPackage,
  fetchFromGitHub,
  writeScriptBin,
}:

buildNpmPackage rec {
  pname = "zotero-pdf-worker-pdfjs";
  version = builtins.substring 0 9 src.rev;

  src = fetchFromGitHub {
    owner = "zotero";
    repo = "pdf.js";
    rev = "68d529d58f39de388c7d68aef0ae24da5dd64000";
    hash = "sha256-l7l/a8m/VDBv7+3tkx4cTfOSjFL6ehufuML7KGnWleM=";
  };

  npmDepsHash = "sha256-JJ9mgzKGYOfyu/5O/VrNL6ImRUCzpcgMOBmLADYM9GQ=";
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
    node_modules/.bin/gulp lib-legacy
  '';

  postInstall = ''
    cp -r build $out/lib/node_modules/pdf.js/build
  '';
}
