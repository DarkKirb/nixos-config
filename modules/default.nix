{
  disko,
  home-manager,
  lib,
  sops-nix,
  ...
}:
{
  imports = [
    disko.nixosModules.default
    home-manager.nixosModules.default
    sops-nix.nixosModules.default
    ./nix
    ./environment
    ./hydra/build-server.nix
    ./secrets/sops.nix
    ./matrix
  ];

  options = {
    system = {
      standardConfig = lib.mkEnableOption "Enable default features of this module";
      isGraphical = lib.mkEnableOption "Whether or not this configuration is a graphical install";
      isInstaller = lib.mkEnableOption "Whether or not this configuration is an installer and has no access to secrets";
      isNSFW = lib.mkEnableOption "Whether or not this configuration is NSFW";
      isIntelGPU = lib.mkEnableOption "Whether or not this configuration uses an Intel GPU";
      wm = lib.mkOption {
        type = lib.types.enum [
          "sway"
          "kde"
        ];
        default = "kde";
        description = "Which window manager to use";
      };
      rootDiskType = lib.mkOption {
        type = lib.types.enum [
          "ssd"
          "hdd"
          "sdcard"
        ];
        default = "ssd";
        description = "What kind of disk the root partition is on";
      };
    };
  };
}
