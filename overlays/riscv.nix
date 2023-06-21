args: self: prev: let
  pkgsX86 = import args.nixpkgs {
    system = "x86_64-linux";
    crossSystem = "riscv64-linux";
    overlays = [args.self.overlays.riscv64-linux];
    config.allowUnfree = true;
  };
in {
  pandoc = self.writeScriptBin "pandoc" "true";
  inherit (pkgsX86) gccgo gfortran;
  meson = prev.meson.overrideAttrs (_: {
    doCheck = false;
    doInstallCheck = false;
  });
  libarchive = prev.libarchive.overrideAttrs (_: {
    doCheck = false;
    doInstallCheck = false;
  });
  openldap = prev.openldap.overrideAttrs (_: {
    doCheck = false;
    doInstallCheck = false;
  });
  bind = prev.bind.overrideAttrs (_: {
    doCheck = false;
    doInstallCheck = false;
  });
  restic = prev.restic.overrideAttrs (_: {
    doCheck = false;
    doInstallCheck = false;
  });
}
