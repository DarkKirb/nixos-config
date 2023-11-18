args: {
  pkgs,
  nixpkgs,
  nix-gaming,
  ...
}: let
  wine = nix-gaming.packages.x86_64-linux.wine-ge.overrideAttrs (super: {
    patches =
      super.patches
      or []
      ++ [
        ./wine/server-default_integrity/0001-server-Create-processes-using-a-limited-administrato.patch
        ./wine/server-default_integrity/0002-shell32-Implement-the-runas-verb.patch
        ./wine/server-default_integrity/0003-wine.inf-Set-the-EnableLUA-value-to-1.patch
        ./wine/server-default_integrity/0004-msi-Create-the-custom-action-server-as-an-elevated-p.patch
        ./wine/server-default_integrity/0005-ntdll-Always-start-the-initial-process-through-start.patch
        ./wine/server-default_integrity/0006-kernelbase-Elevate-processes-if-requested-in-CreateP.patch
        ./wine/server-default_integrity/0007-ntdll-Elevate-processes-if-requested-in-RtlCreateUse.patch
      ];
  });
in {
  home.packages = [
    pkgs.xivlauncher
    pkgs.prismlauncher
    pkgs.mgba
    pkgs.citra
    wine
  ];
}
