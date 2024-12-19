{ buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "zotero-reader-epubjs";
  version = "fa48e978c7001a3b3b487f738756600e312fe23d";

  src = fetchFromGitHub {
    owner = "zotero";
    repo = "zotero";
    rev = version;
    hash = "sha256-ms7sq5XrvagskTgtXXLtI7W/Q3z/6bo+2v1YSytP5qc=";
    fetchSubmodules = true;
  };

  sourceRoot = "source/reader/epubjs/epub.js";

  npmDepsHash = "sha256-JYOEDX6SxB4Epwq5PZ5Y+EJO6UGKsOBIm2XIAqOwDO8=";
  npmRebuildFlags = [ "--ignore-scripts" ];
}
