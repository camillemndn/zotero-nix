{ buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "zotero-translators";
  version = builtins.substring 0 9 src.rev;

  src = fetchFromGitHub {
    owner = "zotero";
    repo = "translators";
    rev = "c528844c3612b8e77eb494eec9d7bf5a6997bf1d";
    hash = "sha256-EhJSNZym7vCdukhdbCyTOb84KaM5E93uM5Ftv/ntHhQ=";
  };

  npmDepsHash = "sha256-bC4HO492c+MSR2+LtyM4qTxZz1LwqPuYjqNgVuCVHYE=";

  # Avoid downloading binary in sandbox
  postPatch = ''
    echo "chromedriver_skip_download=true" >> .npmrc
  '';

  dontNpmBuild = true;
}
