{ pkgs, lib, ... }: {
  home.packages = with pkgs; [
    ghidra
    android-studio
    thunderbird
  ];
}
