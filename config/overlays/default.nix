{
  config,
  nixos-config,
  ...
}:
{
  nixpkgs.overlays = [
    nixos-config.overlays.default
  ];
  environment.etc."nix/inputs/nixpkgs-overlays/default.nix".text = ''
    (import <nixpkgs/lib>).composeManyExtensions (import <nixos-config>).outputs.nixosConfigurations.${config.networking.hostName}.config.nixpkgs.overlays
  '';
}
