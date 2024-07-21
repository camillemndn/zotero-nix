{ buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "zotero-reader-epubjs";
  version = builtins.substring 0 9 src.rev;

  src = fetchFromGitHub {
    owner = "zotero";
    repo = "epub.js";
    rev = "a621d3727bc75ad7e49f2d70941dc969be65dd21";
    hash = "sha256-BnjNdvD75QgRwjV8v5hjOAz+UEPK8sv8oePjQVT7Y+0=";
  };

  npmDepsHash = "sha256-JYOEDX6SxB4Epwq5PZ5Y+EJO6UGKsOBIm2XIAqOwDO8=";
  npmRebuildFlags = [ "--ignore-scripts" ];
}
