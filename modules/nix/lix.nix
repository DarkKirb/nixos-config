{
  lix-module,
  inTester,
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = if inTester then [ ] else [ lix-module.nixosModules.default ];

  environment.systemPackages = lib.mkIf config.nix.enable [
    pkgs.git
  ];
}
