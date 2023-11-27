{ lib
, buildNpmPackage
, fetchFromGitHub
, firefox-esr-102 ? (callPackage
    (fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/82527892e46a17cff16c5842e2354a7f5b8d0025.tar.gz";
      sha256 = "1ip3w3cr3w19p5xrvsazffimicf6qk6dn94biradyk4mzjk0pgad";
    })
    { }).firefox-esr-102
, makeDesktopItem
, copyDesktopItems
, python3
, unzip
, zip
, perl
, rsync
, callPackage
}:

buildNpmPackage rec {
  pname = "zotero";
  version = "7.0.0.SOURCE.${builtins.substring 0 9 src.rev}";

  src = fetchFromGitHub {
    owner = "zotero";
    repo = "zotero";
    rev = "0cab24fb89b64a78dcd1d0fb2d77d032ad87f163";
    hash = "sha256-WLWnZD/S2q5WUkZLQSX8EdWTeTbI9g71lpzUPdu+dCc=";
    fetchSubmodules = true;
  };

  npmDepsHash = "sha256-rZU5fuKlLXx4fSMTlMJUtKRPO0Wd+KW6trOWnxEvFrc=";
  npmFlags = [ "--legacy-peer-deps" ];
  NODE_OPTIONS = "--openssl-legacy-provider";

  patches = [ ./dark-tabs.patch ];

  postPatch = ''
    # Replace Git submodules by their respective NPM packages
    rm -rf resource/SingleFile chrome/content/zotero/xpcom/utilities reader pdf-worker translators note-editor
    cp -Lr ${callPackage ./single-file.nix {}}/lib/node_modules/single-file resource/SingleFile
    cp -Lr ${callPackage ./xpcom-utilities.nix {}}/lib/node_modules/@zotero/utilities chrome/content/zotero/xpcom/utilities
    cp -r ${callPackage ./reader {}}/lib/node_modules/pdf-reader reader
    cp -r ${callPackage ./pdf-worker {}}/lib/node_modules/pdf-worker pdf-worker
    cp -Lr ${callPackage ./translators.nix {}}/lib/node_modules/translators-check translators
    cp -Lr ${callPackage ./note-editor.nix {}}/lib/node_modules/zotero-note-editor note-editor
    chmod +w {reader,pdf-worker} -R
    (
      cd reader
      rm -rf epubjs/epub.js pdfjs/pdf.js
      cp -Lr ${callPackage ./reader/epubjs.nix {}}/lib/node_modules/epubjs epubjs/epub.js 
      cp -Lr ${callPackage ./reader/pdfjs.nix {}}/lib/node_modules/pdf.js pdfjs/pdf.js
    )
    (
      cd pdf-worker
      rm -rf pdf.js
      cp -Lr ${callPackage ./pdf-worker/pdfjs.nix {}}/lib/node_modules/pdf.js pdf.js
    )
    chmod +w . -R

    # Avoid npm install and using git
    find js-build -type f | xargs sed -i 's/npm ci/#npm ci/g'
    find js-build -type f | xargs sed -i 's/git/#git/g'

    # Avoid npm build since it is already built
    sed -i js-build/note-editor.js -e 's/npm run build/#npm run build/g'

    # Zotero standalone build scripts
    patchShebangs app/build.sh app/scripts/{dir_build,fetch_xulrunner,prepare_build}
    
    # Fix Firefox runtime fetching 
    sed -i app/scripts/fetch_xulrunner \
    -e '/updateAuto/,+7d' \
    -e '/GECKO_VERSION_LINUX/,+30d' \
    -e '/BUILD_LINUX == 1/a \  pushd firefox; modify_omni; popd'

    # Use the hash from this revision
    sed -i app/scripts/dir_build -Ee 's/(.*hash=).*/\1${src.rev}/'

    # Make the copied files writable after rsync and remove multiple arch build
    sed -i app/build.sh \
      -Ee 's|(rsync -a.*)|\1; chmod -R +w $BUILD_DIR|' \
      -e 's/x86_64//g' \
      -e 's/firefox-"/firefox"/g' \
      -e 's/Zotero_linux-/Zotero_linux/g' \
      -e 's/for arch in \$archs/for arch in ""/g' \
      -e '/linux\/updater.tar.xz/,+3d'
  '';

  nativeBuildInputs = [ copyDesktopItems perl python3 rsync unzip zip ];

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = "${pname} -url %U";
      icon = "zotero";
      comment = meta.description;
      desktopName = "Zotero";
      genericName = "Reference Management";
      categories = [ "Office" "Database" ];
      startupNotify = true;
      startupWMClass = pname;
      mimeTypes = [ "x-scheme-handler/zotero" "text/plain" ];
      terminal = false;
      actions = {
        profile-manager-window = {
          name = "Profile Manager";
          exec = "${pname} -P";
        };
      };
    })
  ];

  postBuild = ''
    mkdir app/xulrunner
    cp -Lr ${firefox-esr-102}/lib/firefox app/xulrunner
    chmod -R +w /build
    app/scripts/dir_build -p l
    
    patchShebangs app/staging/Zotero_linux/zotero
    sed -i app/staging/Zotero_linux/zotero -e '/MOZ_LEGACY_PROFILES/a export MOZ_ENABLE_WAYLAND=1'
  '';

  installPhase = ''
    mkdir -p $out/{bin,lib}
    cp -Lr app/staging/Zotero_linux $out/lib/zotero
    ln -s $out/lib/zotero/zotero $out/bin

    for size in 16 32 48 256; do
      install -Dm444 app/staging/Zotero_linux/chrome/icons/default/default$size.png \
        $out/share/icons/hicolor/''${size}x''${size}/apps/zotero.png
    done
    
    runHook postInstall
  '';

  meta = with lib; {
    description = "Zotero is a free, easy-to-use tool to help you collect, organize, cite, and share your research sources";
    homepage = "https://github.com/zotero/zotero";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ camillemndn ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
