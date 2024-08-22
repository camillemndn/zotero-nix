{
  buildNpmPackage,
  fetchFromGitHub,
  writeScriptBin,
}:

buildNpmPackage rec {
  pname = "zotero-pdf-worker-pdfjs";
  version = builtins.substring 0 9 src.rev;

  src = fetchFromGitHub {
    owner = "zotero";
    repo = "pdf.js";
    rev = "b658eb6edc972f21b4518a932e1836e7752ebe27";
    hash = "sha256-PKaxJK85wRd+w8R/o70PVnAH9/SwfHJ6EhhC/33enMQ=";
  };

  npmDepsHash = "sha256-NsS6odvDBWXWXtDmmV3YqT8gtcwTqYtZwxawQWYMxbM=";
  makeCacheWritable = true;

  nativeBuildInputs = [
    (writeScriptBin "prebuild" ''
      echo "Skip prebuild step."
    '')
  ];

  # Add a version number
  postPatch = ''
    sed -i package*.json -e '/"name": "pdf.js"/a "version": "1.0.0",'
  '';

  buildPhase = ''
    node_modules/.bin/gulp lib-legacy
  '';

  postInstall = ''
    cp -r build $out/lib/node_modules/pdf.js/build
  '';
}
