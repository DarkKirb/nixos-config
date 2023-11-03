args: self: prev: let
  pkgsX86 = import args.nixpkgs {
    system = "x86_64-linux";
    crossSystem = "riscv64-linux";
    overlays = [args.self.overlays.riscv64-linux];
    config.allowUnfree = true;
  };
  lib = pkgsX86.lib;
in {
  pandoc = self.writeScriptBin "pandoc" "true";
  inherit (pkgsX86) nix;
  bind = prev.bind.overrideAttrs (_: {
    doCheck = false;
    doInstallCheck = false;
  });
  restic = prev.restic.overrideAttrs (_: {
    doCheck = false;
    doInstallCheck = false;
  });
  python3 = prev.python3.override {
    packageOverrides = final: prev: {
      pytest-xdist = prev.pytest-xdist.overrideAttrs (_: {
        doCheck = false;
        doInstallCheck = false;
      });
    };
  };
  python3Packages = self.python3.pkgs;
  python310 = prev.python310.override {
    packageOverrides = final: prev: {
      pytest-xdist = prev.pytest-xdist.overrideAttrs (_: {
        doCheck = false;
        doInstallCheck = false;
      });
    };
  };
  python310Packages = self.python310.pkgs;
}
