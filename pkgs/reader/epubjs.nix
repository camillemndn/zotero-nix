{ buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "zotero-reader-epubjs";
  version = builtins.substring 0 9 src.rev;

  src = fetchFromGitHub {
    owner = "zotero";
    repo = "epub.js";
    rev = "fc79087dc9eb6676c7f5a3e2069c4bfaf424d2ec";
    hash = "sha256-m/GYREm+waD4d5PUf/lGoqJEqoxFDuoNPZBo4CHfp7A=";
  };

  npmDepsHash = "sha256-JYOEDX6SxB4Epwq5PZ5Y+EJO6UGKsOBIm2XIAqOwDO8=";
  npmRebuildFlags = [ "--ignore-scripts" ];
}
