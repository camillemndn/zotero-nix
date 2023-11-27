{ buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "zotero-single-file";
  version = builtins.substring 0 9 src.rev;

  src = fetchFromGitHub {
    owner = "gildas-lormeau";
    repo = "SingleFile";
    rev = "0bca0227851348ef9bbaec780e88deb32b1cc03d";
    hash = "sha256-iP1eVkBOkdowdZlG2i/exJrSWEzyD3/HGf2maQNN7Oc=";
  };

  npmDepsHash = "sha256-wsoXotl8FLkWZYcKGUCCGc1iZn5dlmlHBdLZh0H4Zuc=";
  npmFlags = [ "--legacy-peer-deps" ];
  NODE_OPTIONS = "--openssl-legacy-provider";
  dontNpmBuild = true;
}
