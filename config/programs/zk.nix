{
  pkgs,
  emanote,
  ...
}: {
  imports = [emanote.homeManagerModule];
  home.packages = [pkgs.zk];
  services.emanote = {
    enable = true;
    notes = [
      "/home/darkkirb/Data/notes"
    ];
    package = emanote.packages.${pkgs.system}.default;
  };
}
