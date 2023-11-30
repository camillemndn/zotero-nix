{ buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "zotero-translators";
  version = builtins.substring 0 9 src.rev;

  src = fetchFromGitHub {
    owner = "zotero";
    repo = "translators";
    rev = "db2771d52d89d1480ff98efbd6968565893f2184";
    hash = "sha256-OhG1Rw67Zc6A96FZ059fBvRxPPc7ppHpzmkuX2pI5n8=";
  };

  npmDepsHash = "sha256-bQp1PjT9G5n7gw5o2ksZnFTMDqbjTpuKWPv7d+Gdkvw=";
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
