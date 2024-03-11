{ buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "zotero-note-editor";
  version = builtins.substring 0 9 src.rev;

  src = fetchFromGitHub {
    owner = "zotero";
    repo = "note-editor";
    rev = "508a90a66d030c2033039f5a256c1ab252097dc4";
    hash = "sha256-cS55zX436drs/YK2wXUhPXUSRofa++oxwv/A3hc6dTg=";
  };

  npmDepsHash = "sha256-dvlgXixWGW4pKiAr36fgrWeMY/XRTnp4Yo9MWwpeWkE=";

  postInstall = ''
    cp -r build $out/lib/node_modules/zotero-note-editor/build
  '';
}
