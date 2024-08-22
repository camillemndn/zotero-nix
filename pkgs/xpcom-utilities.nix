{ buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "zotero-xpcom-utilities";
  version = builtins.substring 0 9 src.rev;

  src = fetchFromGitHub {
    owner = "zotero";
    repo = "utilities";
    rev = "98fd1540f3840be85e2ed0b4bf0fa29426db1afd";
    hash = "sha256-3W1+kxZFfsHZ0AOb/ZoIwQpb0y69pkO9nMaSOYzPqmA=";
  };

  npmDepsHash = "sha256-tWDADhAeXG0HSvFnpdGOya3CjSb0i2aR3E1Y3r1J81o=";
  dontNpmBuild = true;
}
