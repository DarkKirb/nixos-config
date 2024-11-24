{
  impermanence,
  inputs,
  inputs',
  config,
  sops-nix,
  self,
  nixpkgs,
  ...
}:
{
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "backup-${self.shortRev or nixpkgs.shortRev}";
    extraSpecialArgs = inputs // {
      inherit inputs inputs';
      systemConfig = config;
    };
    sharedModules = [
      ./common
      "${impermanence}/home-manager.nix"
      sops-nix.homeManagerModules.sops
    ];
  };
}
