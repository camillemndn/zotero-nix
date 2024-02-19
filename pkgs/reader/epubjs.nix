{ buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "zotero-reader-epubjs";
  version = builtins.substring 0 9 src.rev;

  src = fetchFromGitHub {
    owner = "zotero";
    repo = "epub.js";
    rev = "0beb4ebb54980772196771affe9763a66b0eb008";
    hash = "sha256-I6ba/crqpb6FtxkVrBBmvw9BawRWsIDAD/W0Oa4e9ZM=";
  };

  npmDepsHash = "sha256-fau29rCdET6lmyvUvzXRzygfVdfIRU8Vd9JcmSgBy5o=";
  npmRebuildFlags = [ "--ignore-scripts" ];
}
