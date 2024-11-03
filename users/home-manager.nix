{
  impermanence,
  inputs,
  inputs',
  config,
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
    ];
  };
}
