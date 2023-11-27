{ buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "zotero-xpcom-utilities";
  version = builtins.substring 0 9 src.rev;

  src = fetchFromGitHub {
    owner = "zotero";
    repo = "utilities";
    rev = "9c89b23153ce621ed0f1d581a5e32248704c6fb7";
    hash = "sha256-RAy3Qp55slCY/nYIuQkl3jAc7Bd/pt8QZHCCae+Bm18=";
  };

  npmDepsHash = "sha256-tWDADhAeXG0HSvFnpdGOya3CjSb0i2aR3E1Y3r1J81o=";
  npmFlags = [ "--legacy-peer-deps" ];
  NODE_OPTIONS = "--openssl-legacy-provider";
  dontNpmBuild = true;
}
