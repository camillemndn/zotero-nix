{ buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "zotero-translators";
  version = builtins.substring 0 9 src.rev;

  src = fetchFromGitHub {
    owner = "zotero";
    repo = "translators";
    rev = "4a8bd03064a56420dcfa0910791eba1b9447e99a";
    hash = "sha256-4z+AGy4mBFaUxRAOKswcpPN7nwE7mGP+uMnIqtsl5jY=";
  };

  npmDepsHash = "sha256-qr/XMbId/FYt14O2IztSBAPd+mR7h8LJg4KA+IUyeGk=";

  postPatch = ''
    # Remove unused dependency
    sed -i package.json -e '/eslint-plugin-zotero-translator/d'

    # Avoid downloading binary in sandbox
    echo "chromedriver_skip_download=true" >> .npmrc
  '';

  dontNpmBuild = true;
}
