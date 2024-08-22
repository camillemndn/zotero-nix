{ buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "zotero-translators";
  version = builtins.substring 0 9 src.rev;

  src = fetchFromGitHub {
    owner = "zotero";
    repo = "translators";
    rev = "1124865649a3835ac0164730e022ff26a743771f";
    hash = "sha256-0l8vajxi31aC5+aX6q5wdtoL4SWE8KgGZH2fQz5HX1A=";
  };

  npmDepsHash = "sha256-bC4HO492c+MSR2+LtyM4qTxZz1LwqPuYjqNgVuCVHYE=";

  # Avoid downloading binary in sandbox
  postPatch = ''
    echo "chromedriver_skip_download=true" >> .npmrc
  '';

  dontNpmBuild = true;
}
