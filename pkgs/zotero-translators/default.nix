{ buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "zotero-translators";
  version = "fa48e978c7001a3b3b487f738756600e312fe23d";

  src = fetchFromGitHub {
    owner = "zotero";
    repo = "zotero";
    rev = version;
    hash = "sha256-ms7sq5XrvagskTgtXXLtI7W/Q3z/6bo+2v1YSytP5qc=";
    fetchSubmodules = true;
  };

  sourceRoot = "source/translators";

  npmDepsHash = "sha256-bC4HO492c+MSR2+LtyM4qTxZz1LwqPuYjqNgVuCVHYE=";

  # Avoid downloading binary in sandbox
  postPatch = ''
    echo "chromedriver_skip_download=true" >> .npmrc
  '';

  dontNpmBuild = true;
}
