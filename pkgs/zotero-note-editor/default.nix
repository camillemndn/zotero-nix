{ buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "zotero-note-editor";
  version = "7.0.11";

  src = fetchFromGitHub {
    owner = "zotero";
    repo = "zotero";
    rev = version;
    hash = "sha256-eTlysgISTjimKvVhTbnr4Dj4gcN7qAVXAjuUmVqrVlE=";
    fetchSubmodules = true;
  };

  sourceRoot = "source/note-editor";

  npmDepsHash = "sha256-GjISb8XzW1ZxHwHG3ybhv0/ZUTcY99LsGslQ+9/iDBw=";

  postInstall = ''
    cp -r build $out/lib/node_modules/zotero-note-editor/build
  '';
}
