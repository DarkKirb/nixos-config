{
  impermanence,
  inputs,
  inputs',
  config,
  sops-nix,
  nur,
  ...
}: {
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "backup";
    extraSpecialArgs =
      inputs
      // {
        inherit inputs inputs';
        systemConfig = config;
      };
    sharedModules = [
      ./common
      "${impermanence}/home-manager.nix"
      sops-nix.homeManagerModules.sops
      nur.nixosModules.nur
    ];
  };
}
