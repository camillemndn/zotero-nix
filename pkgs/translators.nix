{ buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "zotero-translators";
  version = builtins.substring 0 9 src.rev;

  src = fetchFromGitHub {
    owner = "zotero";
    repo = "translators";
    rev = "450efe2d873be12131e33f78e37084264ccf6ed0";
    hash = "sha256-eTMHNQI35UabY4R8dT+ibaoZ9Dog61w3c/K+SIhbEUA=";
  };

  npmDepsHash = "sha256-qr/XMbId/FYt14O2IztSBAPd+mR7h8LJg4KA+IUyeGk=";
  npmFlags = [ "--legacy-peer-deps" ];
  NODE_OPTIONS = "--openssl-legacy-provider";

  postPatch = ''
    # Remove unused dependency
    sed -i package.json -e '/eslint-plugin-zotero-translator/d'

    # Avoid downloading binary in sandbox
    echo "chromedriver_skip_download=true" >> .npmrc
  '';

  dontNpmBuild = true;
}
