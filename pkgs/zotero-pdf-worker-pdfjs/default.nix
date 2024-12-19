{
  buildNpmPackage,
  fetchFromGitHub,
  writeScriptBin,
}:

buildNpmPackage rec {
  pname = "zotero-pdf-worker-pdfjs";
  version = "fa48e978c7001a3b3b487f738756600e312fe23d";

  src = fetchFromGitHub {
    owner = "zotero";
    repo = "zotero";
    rev = version;
    hash = "sha256-ms7sq5XrvagskTgtXXLtI7W/Q3z/6bo+2v1YSytP5qc=";
    fetchSubmodules = true;
  };

  sourceRoot = "source/pdf-worker/pdf.js";

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
    node_modules/.bin/gulp lib-legacy
  '';

  postInstall = ''
    cp -r build $out/lib/node_modules/pdf.js/build
  '';
}
