{
  lix-module,
  inTester,
  config,
  pkgs,
  ...
}: {
  imports =
    if inTester
    then []
    else [lix-module.nixosModules.default];

  environment.systemPackages = mkIf config.nix.enable [
    pkgs.gitMinimal
  ];
}
