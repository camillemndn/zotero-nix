{ buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "zotero-single-file";
  version = "7.0.11";

  src = fetchFromGitHub {
    owner = "zotero";
    repo = "zotero";
    rev = version;
    hash = "sha256-eTlysgISTjimKvVhTbnr4Dj4gcN7qAVXAjuUmVqrVlE=";
    fetchSubmodules = true;
  };

  sourceRoot = "source/resource/SingleFile";

  npmDepsHash = "sha256-wsoXotl8FLkWZYcKGUCCGc1iZn5dlmlHBdLZh0H4Zuc=";
  dontNpmBuild = true;
}
