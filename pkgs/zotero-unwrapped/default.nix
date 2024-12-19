{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  zotero-note-editor,
  zotero-pdf-worker,
  zotero-reader,
  zotero-single-file,
  zotero-translators,
  zotero-xpcom-utilities,
  firefox-esr-128,
  makeDesktopItem,
  copyDesktopItems,
  glib,
  glibc,
  gtk3,
  makeBinaryWrapper,
  pciutils,
  perl,
  python3,
  rsync,
  unzip,
  zip,
  writeShellScriptBin,
  nix-update,

}:

buildNpmPackage rec {
  pname = "zotero";
  version = "fa48e978c7001a3b3b487f738756600e312fe23d";

  src = fetchFromGitHub {
    owner = "zotero";
    repo = "zotero";
    rev = version;
    hash = "sha256-ms7sq5XrvagskTgtXXLtI7W/Q3z/6bo+2v1YSytP5qc=";
    fetchSubmodules = true;
  };

  npmDepsHash = "sha256-qWeUeiwM6sCNovSoaEP3b42VTnCFSWLK9y8qPnWcSTE=";

  postPatch = ''
    # Replace Git submodules by their respective NPM packages
    rm -r resource/SingleFile chrome/content/zotero/xpcom/utilities reader pdf-worker translators note-editor
    cp -Lr ${zotero-single-file}/lib/node_modules/single-file resource/SingleFile
    cp -Lr ${zotero-xpcom-utilities}/lib/node_modules/@zotero/utilities chrome/content/zotero/xpcom/utilities
    cp -r ${zotero-reader}/lib/node_modules/pdf-reader reader
    cp -r ${zotero-pdf-worker}/lib/node_modules/pdf-worker pdf-worker
    cp -Lr ${zotero-translators}/lib/node_modules/translators-check translators
    cp -Lr ${zotero-note-editor}/lib/node_modules/zotero-note-editor note-editor
    chmod +w . -R

    # Avoid npm install and using git
    find js-build -type f | xargs sed -i 's/npm ci/#npm ci/g'
    find js-build -type f | xargs sed -i 's/git/#git/g'

    # Avoid npm build since it is already built
    sed -i js-build/note-editor.js -e 's/npm run build/#npm run build/g'

    # Zotero standalone build scripts
    patchShebangs app/build.sh app/scripts/{dir_build,fetch_xulrunner,prepare_build}

    # Don't fetch Firefox runtime
    sed -i app/scripts/fetch_xulrunner \
    -e '/updateAuto/,+7d' \
    -e 's/arches=.*/arches=""/' \
    -e '/BUILD_LINUX == 1/a pushd firefox-x86_64; modify_omni x86_64; popd'

    # Fix version
    sed -i app/scripts/dir_build \
      -Ee 's/(.*hash=).*/\1release/' \
      -e 's/-c $CHANNEL/-c release/'

    sed -i app/build.sh \
      -e 's/\(rsync -a.*\)/\1; chmod -R +w ./' \
      -e '/updater.tar.xz/d' \
      -e '/$APPDIR\/updater/d' \
      -e '/# Copy icons/a mkdir -p $APPDIR\/icons'
  '';

  nativeBuildInputs = [
    copyDesktopItems
    gtk3
    makeBinaryWrapper
    perl
    python3
    rsync
    unzip
    zip
  ];

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = "${pname} -url %U";
      icon = "zotero";
      comment = meta.description;
      desktopName = "Zotero";
      genericName = "Reference Management";
      categories = [
        "Office"
        "Database"
      ];
      startupNotify = true;
      startupWMClass = pname;
      mimeTypes = [
        "x-scheme-handler/zotero"
        "text/plain"
      ];
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
    cp -Lr ${firefox-esr-128}/lib/firefox app/xulrunner/firefox-x86_64
    chmod -R +w /build
    SKIP_32=1 app/scripts/dir_build -p l
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib}
    patchShebangs app/staging/Zotero_linux-x86_64/zotero
    cp -Lr app/staging/Zotero_linux-x86_64 $out/lib/zotero

    runHook postInstall
  '';

  postFixup = ''
    makeBinaryWrapper $out/{lib/zotero,bin}/zotero \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          glib.out
          glibc
          pciutils
          gtk3
        ]
      }

    patchelf $out/lib/zotero/zotero-bin \
      --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker)

    for size in 32 64 128; do
      install -Dm444 app/staging/Zotero_linux-x86_64/icons/icon$size.png \
        $out/share/icons/hicolor/''${size}x''${size}/apps/zotero.png
    done

    install -Dm444 app/staging/Zotero_linux-x86_64/icons/symbolic.svg \
      $out/share/icons/hicolor/scalable/apps/zotero.svg

    rm $out/lib/zotero/mozilla.cfg
  '';

  passthru = {
    inherit gtk3;
    updateScript = writeShellScriptBin "zotero-update" (
      lib.concatMapStringsSep "\n" (pkg: "${nix-update}/bin/nix-update --flake --version=branch ${pkg}") (
        lib.attrNames (import ../../.).packages.x86_64-linux
      )
    );
  };

  meta = with lib; {
    description = "Zotero is a free, easy-to-use tool to help you collect, organize, cite, and share your research sources";
    homepage = "https://github.com/zotero/zotero";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ camillemndn ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
