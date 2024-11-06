{config, ...}: {
  home-manager.users.darkkirb.imports = mkIf config.isGraphical [
    ./home-manager.nix
  ];
}
