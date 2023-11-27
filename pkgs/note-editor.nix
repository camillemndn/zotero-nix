{ buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "zotero-note-editor";
  version = builtins.substring 0 9 src.rev;

  src = fetchFromGitHub {
    owner = "zotero";
    repo = "note-editor";
    rev = "e2e3009bbce0070488989c8678bb2da3e22d7514";
    hash = "sha256-PXaoF4piXyN2r4WmL00aZv56VcN06xwbj9l1RoQRZww=";
  };

  npmDepsHash = "sha256-3lKk9M9UMH2JOZwfmQQpzGezU5zL0dkF+SuT735Cu/A=";
  npmFlags = [ "--legacy-peer-deps" ];
  NODE_OPTIONS = "--openssl-legacy-provider";

  postInstall = ''
    cp -r build $out/lib/node_modules/zotero-note-editor/build
  '';
}
