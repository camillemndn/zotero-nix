{ buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "zotero-reader-epubjs";
  version = "7.0.1";

  src = fetchFromGitHub {
    owner = "zotero";
    repo = "zotero";
    rev = version;
    hash = "sha256-VLl7vuk7x1DEBKFiRBHTLsYxKHoC2aah9P+rhQx6AbQ=";
    fetchSubmodules = true;
  };

  sourceRoot = "source/reader/epubjs/epub.js";

  npmDepsHash = "sha256-JYOEDX6SxB4Epwq5PZ5Y+EJO6UGKsOBIm2XIAqOwDO8=";
  npmRebuildFlags = [ "--ignore-scripts" ];
}
