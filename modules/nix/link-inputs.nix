{
  lib,
  pureInputs,
  config,
  ...
}:
let
  # Taken from https://github.com/gytis-ivaskevicius/flake-utils-plus/blob/master/lib/options.nix
  inherit (lib) filterAttrs mapAttrs';
  flakes = filterAttrs (name: value: (value ? outputs)) pureInputs // {
    nixos-config = pureInputs.self;
  };
  nixRegistry = builtins.mapAttrs (name: v: { flake = v; }) flakes;
  cfg = config.nix.autoRegistry;
in
{
  options = {
    nix.autoRegistry.enable = lib.mkEnableOption "Enable automatic registry";
  };
  config = {
    nix.autoRegistry.enable = lib.mkDefault config.nix.defaultSettings.enable;
    assertions = [
      {
        assertion = cfg.enable -> config.nix.enable;
        message = "Configuring the nix registry only makes sense when Nix is enabled";
      }
    ];
    nix.registry = lib.mkIf cfg.enable nixRegistry;
    environment.etc = lib.mkIf cfg.enable (
      mapAttrs' (name: value: {
        name = "nix/inputs/${name}";
        value = lib.mkIf config.nix.enable {
          source = value.outPath;
        };
      }) flakes
    );
    nix.nixPath = lib.mkIf cfg.enable [ "/etc/nix/inputs" ];
  };
}
