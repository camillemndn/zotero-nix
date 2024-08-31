{ buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "zotero-xpcom-utilities";
  version = builtins.substring 0 9 src.rev;

  src = fetchFromGitHub {
    owner = "zotero";
    repo = "utilities";
    rev = "e00d98d3a11f6233651a052c108117cf44873edc";
    hash = "sha256-Pr6Htc1CdNubcZSt3ASwAYagJdPAbdA1a9RXyiqZSJY=";
  };

  npmDepsHash = "sha256-tWDADhAeXG0HSvFnpdGOya3CjSb0i2aR3E1Y3r1J81o=";
  dontNpmBuild = true;
}
