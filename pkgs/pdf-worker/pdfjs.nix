{
  buildNpmPackage,
  fetchFromGitHub,
  writeScriptBin,
}:

buildNpmPackage rec {
  pname = "zotero-pdf-worker-pdfjs";
  version = "7.0.1";

  src = fetchFromGitHub {
    owner = "zotero";
    repo = "zotero";
    rev = version;
    hash = "sha256-VLl7vuk7x1DEBKFiRBHTLsYxKHoC2aah9P+rhQx6AbQ=";
    fetchSubmodules = true;
  };

  sourceRoot = "source/pdf-worker/pdf.js";

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
