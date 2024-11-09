{pkgs, ...}: {
  imports = [
    ./ff14
  ];
  home.packages = with pkgs; [factorio];
}
