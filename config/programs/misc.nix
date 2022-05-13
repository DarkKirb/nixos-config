{ pkgs, lib, ... }: {
  home.packages = with pkgs; [
    ghidra
    android-studio
    thunderbird
  ];
  xdg.configFile."gdb/gdbinit".text = "set auto-load safe-path /nix/store";

}
