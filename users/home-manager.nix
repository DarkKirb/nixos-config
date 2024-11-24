{
  impermanence,
  inputs,
  inputs',
  config,
  sops-nix,
  self,
  nixpkgs,
  system,
  ...
}:
{
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "backup-${self.shortRev or nixpkgs.shortRev}";
    extraSpecialArgs = inputs // {
      inherit inputs inputs' system;
      systemConfig = config;
    };
    sharedModules = [
      ./common
      "${impermanence}/home-manager.nix"
      sops-nix.homeManagerModules.sops
    ];
  };
}
