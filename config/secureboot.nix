{ pkgs, config, ... }: {
  imports = [
    ../modules/systemd-secure-boot
    #    ../modules/systemd-cryptsetup.nix # broken
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
  system.extraSystemBuilderCmds = ''
    substituteAll ${../extra/switch-to-configuration.pl} $out/bin/switch-to-configuration
  '';
}
