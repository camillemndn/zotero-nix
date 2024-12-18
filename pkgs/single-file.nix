{ buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "zotero-single-file";
  version = "7.0.1";

  src = fetchFromGitHub {
    owner = "zotero";
    repo = "zotero";
    rev = version;
    hash = "sha256-VLl7vuk7x1DEBKFiRBHTLsYxKHoC2aah9P+rhQx6AbQ=";
    fetchSubmodules = true;
  };

  sourceRoot = "source/resource/SingleFile";

  npmDepsHash = "sha256-wsoXotl8FLkWZYcKGUCCGc1iZn5dlmlHBdLZh0H4Zuc=";
  dontNpmBuild = true;
}
