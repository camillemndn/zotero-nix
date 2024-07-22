{ buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "zotero-note-editor";
  version = builtins.substring 0 9 src.rev;

  src = fetchFromGitHub {
    owner = "zotero";
    repo = "note-editor";
    rev = "b859def22f4d563bae6409d602eea429618a51e3";
    hash = "sha256-SdgeLJOilIMLVPrUlh7ErJl5S1eZhnNHI1Lxa8zJNGQ=";
  };

  npmDepsHash = "sha256-dvlgXixWGW4pKiAr36fgrWeMY/XRTnp4Yo9MWwpeWkE=";

  postInstall = ''
    cp -r build $out/lib/node_modules/zotero-note-editor/build
  '';
}
