{ buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "zotero-note-editor";
  version = builtins.substring 0 9 src.rev;

  src = fetchFromGitHub {
    owner = "zotero";
    repo = "note-editor";
    rev = "7d1943329e3e2236cd5236f65acd645805455b5f";
    hash = "sha256-ft1hMwBC2p7/LGwqjHEtjh1TMTT5qaTy9WSa4Jdzlqc=";
  };

  npmDepsHash = "sha256-3lKk9M9UMH2JOZwfmQQpzGezU5zL0dkF+SuT735Cu/A=";
  npmFlags = [ "--legacy-peer-deps" ];
  NODE_OPTIONS = "--openssl-legacy-provider";

  postInstall = ''
    cp -r build $out/lib/node_modules/zotero-note-editor/build
  '';
}
