{
  lib,
  callPackage,
  buildPythonPackage,
  qt5,
  pytest,
  mock,
  babel,
  pyqt5,
  xlib,
  pyserial,
  appdirs,
  wcwidth,
  setuptools,
  xkbcommon,
  pkg-config,
  fetchFromGitHub,
  cmarkgfm,
  wayland,
  pywayland,
  fetchPypi,
}: let
  plover-stroke = callPackage ../plover-stroke.nix {};
  rtf-tokenize = callPackage ../../python/rtf-tokenize.nix {};
  pywayland_0_4_7 =
    pywayland.overridePythonAttrs
    (oldAttrs: rec {
      pname = "pywayland";
      version = "0.4.7";

      src = fetchPypi {
        inherit pname version;
        sha256 = "0IMNOPTmY22JCHccIVuZxDhVr41cDcKNkx8bp+5h2CU=";
      };

      doCheck = false;
    });
in
  qt5.mkDerivationWith buildPythonPackage rec {
    pname = "plover";
    version = "fd5668a3ad9bd091289dd2e5e8e2c1dec063d51f";
    src = fetchFromGitHub {
      owner = "openstenoproject";
      repo = "plover";
      rev = "fd5668a3ad9bd091289dd2e5e8e2c1dec063d51f";
      sha256 = "2xvcNcJ07q4BIloGHgmxivqGq1BuXwZY2XWPLbFrdXg=";
    };

    # I'm not sure why we don't find PyQt5 here but there's a similar
    # sed on many of the platforms Plover builds for
    postPatch = ''
      sed -i /PyQt5/d setup.cfg
      substituteInPlace plover_build_utils/setup.py \
        --replace "/usr/share/wayland/wayland.xml" "${wayland}/share/wayland/wayland.xml"
    '';

    checkInputs = [pytest mock];
    propagatedBuildInputs = [
      babel
      pyqt5
      xlib
      pyserial
      appdirs
      wcwidth
      setuptools
      plover-stroke
      rtf-tokenize
      xkbcommon
      cmarkgfm
      pywayland_0_4_7
    ];
    nativeBuildInputs = [
      pkg-config
    ];

    installCheckPhase = "true";

    #dontWrapQtApps = true;

    preFixup = ''
      makeWrapperArgs+=("''${qtWrapperArgs[@]}")
    '';

    meta = {
      homepage = "http://www.openstenoproject.org/";
      description = "Open Source Stenography Software";
      license = lib.licenses.gpl2Plus;
    };
    passthru.updateScript = [
      ../../scripts/update-git.sh
      "https://github.com/openstenoproject/plover"
      "plover/plover/source.json"
    ];
  }
