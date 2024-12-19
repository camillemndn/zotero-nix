{ buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "zotero-xpcom-utilities";
  version = "7.0.11";

  src = fetchFromGitHub {
    owner = "zotero";
    repo = "zotero";
    rev = version;
    hash = "sha256-eTlysgISTjimKvVhTbnr4Dj4gcN7qAVXAjuUmVqrVlE=";
    fetchSubmodules = true;
  };

  sourceRoot = "source/chrome/content/zotero/xpcom/utilities";

  npmDepsHash = "sha256-tWDADhAeXG0HSvFnpdGOya3CjSb0i2aR3E1Y3r1J81o=";
  dontNpmBuild = true;
}
