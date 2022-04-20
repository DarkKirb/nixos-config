{ config, ... }: {
  imports = [
    ../modules/systemd-secure-boot
  ];

  sops.secrets."secureboot/DB.key" = { };
  boot.loader.systemd-boot = {
    editor = false;
    secureBoot = {
      enable = true;
      keyPath = config.sops.secrets."secureboot/DB.key".path;
      certPath = builtins.toString ../efi/DB.crt;
    };
  };
}
