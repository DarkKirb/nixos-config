{ nixpkgs-soundtouch, system, pkgs, nixpkgs, nixpkgs-wxwidgets, ... }: with pkgs;
let
  rawPerlPackages = callPackage "${nixpkgs}/pkgs/top-level/perl-packages.nix" {
    overrides = pkgs: { };
    buildPerl = perl;
  };
  hydra = (callPackage "${nixpkgs}/pkgs/development/tools/misc/hydra/common.nix" {
    version = "2021-08-11";
    src = fetchFromGitHub {
      owner = "NixOS";
      repo = "hydra";
      rev = "9bce425c3304173548d8e822029644bb51d35263";
      sha256 = "sha256-tGzwKNW/odtAYcazWA9bPVSmVXMGKfXsqCA1UYaaxmU=";
    };
    nix = (import nixpkgs-soundtouch { inherit system; }).nixVersions.unstable;
    tests = {
      basic = nixosTests.hydra.hydra-unstable;
    };
  }).overrideAttrs (old: {
    postPatch = ''
      sed -i 's/totalNarSize > maxOutputSize/false/g' src/hydra-queue-runner/build-remote.cc
    '';
  });
  rtf-tokenize = with python3Packages; buildPythonPackage rec {
    pname = "rtf_tokenize";
    version = "1.0.0";
    src = fetchFromGitHub {
      owner = "benoit-pierre";
      repo = pname;
      rev = version;
      sha256 = "1l5pfrggil9knk58r2r84i9msm7mdhddl87hkfk54qqk2sqzc06g";
    };
  };
  plover-stroke = with python3Packages; buildPythonPackage rec {
    pname = "plover_stroke";
    version = "1.0.1";
    src = fetchFromGitHub {
      owner = "benoit-pierre";
      repo = pname;
      rev = version;
      sha256 = "15by14gn2grvn7835hcrijfmccy4bqwvbg38rn8fvgyl6n2zhwzn";
    };
  };
  plover = with python3Packages; libsForQt5.mkDerivationWith buildPythonPackage rec {
    pname = "plover-wayland";
    version = "2022-01-14";
    src = fetchFromGitHub {
      owner = "matteodelabre";
      repo = "plover";
      rev = "fd5668a3ad9bd091289dd2e5e8e2c1dec063d51f";
      sha256 = "0y3mdfqjv3vmv5c0cpvfa2mqdylan44iw1js480sxvklq8sxq6yv";
    };
    patches = [
      (fetchpatch {
        url = "https://github.com/openstenoproject/plover/files/8059650/cache-kb-mapping.txt";
        sha256 = "0rahn1fxa6i2rhpz5dk4pamggn7jjlpx0ksjzvj4w1q1mpngyblx";
      })
    ];
    postPatch = ''
      sed -i /PyQt5/d setup.cfg
      sed -i 's|/usr/share/wayland|${wayland}/share/wayland|' plover_build_utils/setup.py
      sed -i 's|pywayland==|pywayland>=|' reqs/dist.txt
    '';
    checkInputs = [ pytest mock ];
    propagatedBuildInputs = [
      Babel
      pyqt5
      xlib
      pyserial
      appdirs
      wcwidth
      setuptools
      pywayland
      pkg-config
      plover-stroke
      rtf-tokenize
    ];
    dontWrapQtApps = true;
    preBuild = ''
      export PKG_CONFIG="${pkg-config}/bin/pkg-config"
    '';
    preFixup = ''
      makeWrapperArgs+=("''${qtWrapperArgs[@]}")
    '';
    installCheckPhase = "true";
  };
in
{
  nixpkgs.overlays = [
    (self: prev: {
      coreutils = prev.coreutils.overrideAttrs (old: {
        checkPhase = "true";
      });
      soundtouch = nixpkgs-soundtouch.legacyPackages.${system}.soundtouch;
      wxGTK31 = nixpkgs-wxwidgets.legacyPackages.${system}.wxGTK31;
      hydra-unstable = hydra.overrideAttrs (old: {
        patches = [
          ../../extra/hydra.patch
        ];
      });
      plover.dev = plover;
      mosh = prev.mosh.overrideAttrs (old: {
        patches = [
          "${nixpkgs}/pkgs/tools/networking/mosh/ssh_path.patch"
          "${nixpkgs}/pkgs/tools/networking/mosh/mosh-client_path.patch"
          "${nixpkgs}/pkgs/tools/networking/mosh/utempter_path.patch"
          "${nixpkgs}/pkgs/tools/networking/mosh/bash_completion_datadir.patch"
        ];
        postPatch = ''  
        substituteInPlace scripts/mosh.pl \
          --subst-var-by ssh "${openssh}/bin/ssh" \
          --subst-var-by mosh-client "$out/bin/mosh-client"
        '';
        version = "2022-02-04";
        src = pkgs.fetchFromGitHub {
          owner = "mobile-shell";
          repo = "mosh";
          rev = "dbe419d0e069df3fedc212d456449f64d0280c76";
          sha256 = "09mvk9zxclkf4wrkkfzg0p2hx1f74gpymr0a0l3pckmk6za2n3d1";
        };
      });
    })
  ];
}
