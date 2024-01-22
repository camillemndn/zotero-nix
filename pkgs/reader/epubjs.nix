{ buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "zotero-reader-epubjs";
  version = builtins.substring 0 9 src.rev;

  src = fetchFromGitHub {
    owner = "zotero";
    repo = "epub.js";
    rev = "ea03f7fd90b91a18052fa0095776de4c3abdd236";
    hash = "sha256-pzh4G0L5vTNhqiFzAtOWanLJug+G2aRAdGYfy5klj/E=";
  };

  npmDepsHash = "sha256-LwpOG2bMdn13CAGgVf0APcj4R4z4PsKzHUwO8dujsYE=";
  npmFlags = [ "--legacy-peer-deps" ];
  NODE_OPTIONS = "--openssl-legacy-provider";
  # makeCacheWritable = true;

  postPatch = ''
    sed -i package.json -e '/karma-phantomjs-launcher/d'
    cp ${./epubjs-package-lock.patch} package-lock.json
  '';
}
