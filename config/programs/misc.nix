{ pkgs, ... }: {
  home.packages = with pkgs; [
    ghidra
  ];
}
