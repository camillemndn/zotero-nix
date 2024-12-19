{ buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "zotero-single-file";
  version = "fa48e978c7001a3b3b487f738756600e312fe23d";

  src = fetchFromGitHub {
    owner = "zotero";
    repo = "zotero";
    rev = version;
    hash = "sha256-ms7sq5XrvagskTgtXXLtI7W/Q3z/6bo+2v1YSytP5qc=";
    fetchSubmodules = true;
  };

  sourceRoot = "source/resource/SingleFile";

  npmDepsHash = "sha256-wsoXotl8FLkWZYcKGUCCGc1iZn5dlmlHBdLZh0H4Zuc=";
  dontNpmBuild = true;
}
