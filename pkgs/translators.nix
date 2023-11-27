{ buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "zotero-translators";
  version = builtins.substring 0 9 src.rev;

  src = fetchFromGitHub {
    owner = "zotero";
    repo = "translators";
    rev = "fd45efc081bf03bf33af726b46cd83a81770909a";
    hash = "sha256-CYjgH5Nd7Ms3I2qEUPzDsH4NiCIe/AnNHQ0l9Zn09yc=";
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
