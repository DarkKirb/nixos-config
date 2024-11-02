{
  home-manager,
  impermanence,
  inputs,
  inputs',
  config,
  ...
}: {
  imports = [
    "${home-manager}/nixos"
  ];
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
    ];
  };
}
