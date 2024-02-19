{ buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "zotero-note-editor";
  version = builtins.substring 0 9 src.rev;

  src = fetchFromGitHub {
    owner = "zotero";
    repo = "note-editor";
    rev = "fde942f8a238e2753631728dae6cc4c69128d440";
    hash = "sha256-H8ZUquCCYD54rBUPQo1MZmATfQkYASZ/VIWu0UuMhe0=";
  };

  npmDepsHash = "sha256-dvlgXixWGW4pKiAr36fgrWeMY/XRTnp4Yo9MWwpeWkE=";

  postInstall = ''
    cp -r build $out/lib/node_modules/zotero-note-editor/build
  '';
}
