{ buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "zotero-xpcom-utilities";
  version = builtins.substring 0 9 src.rev;

  src = fetchFromGitHub {
    owner = "zotero";
    repo = "utilities";
    rev = "eab0922a2dd3e1254d1ab69e87cb673f208c6257";
    hash = "sha256-n9tOSMf2eJV4gLBFoKmySW41elT/WZrYHXUrglrUHaA=";
  };

  npmDepsHash = "sha256-tWDADhAeXG0HSvFnpdGOya3CjSb0i2aR3E1Y3r1J81o=";
  dontNpmBuild = true;
}
