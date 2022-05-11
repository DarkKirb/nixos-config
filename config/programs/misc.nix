{ pkgs, ... }: {
  home.packages = with pkgs; [
    ghidra
    android-studio
    thunderbird
  ];
}
