{ buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "zotero-note-editor";
  version = builtins.substring 0 9 src.rev;

  src = fetchFromGitHub {
    owner = "zotero";
    repo = "note-editor";
    rev = "de0686ea767e8dae4836eab8466b460223df1d35";
    hash = "sha256-/3ZADiGtrnkCGa0CZ20DO7JanS15xUc8lYAo11ybNdY=";
  };

  npmDepsHash = "sha256-GjISb8XzW1ZxHwHG3ybhv0/ZUTcY99LsGslQ+9/iDBw=";

  postInstall = ''
    cp -r build $out/lib/node_modules/zotero-note-editor/build
  '';
}
