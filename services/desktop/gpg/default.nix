{
  config,
  pkgs,
  lib,
  systemConfig,
  ...
}:
{
  programs.gpg = {
    enable = systemConfig.system.isGraphical;
    homedir = "${config.xdg.dataHome}/gnupg";
    mutableKeys = false;
    mutableTrust = false;
    scdaemonSettings.disable-ccid = true;
    publicKeys = [
      {
        source = ./keys/0xB4E3D4801C49EC5E.asc;
        trust = "ultimate";
      }
    ];
  };
  services.gpg-agent = {
    enable = systemConfig.system.isGraphical;
    pinentryPackage = pkgs.pinentry-qt;
    enableExtraSocket = true;
  };
  sops.secrets."pgp/0xB4E3D4801C49EC5E.asc".sopsFile = ./privkey.yaml;
  systemd.user.services.import-gpg-privkey = lib.mkIf systemConfig.system.isGraphical {
    Unit = {
      Description = "Imports the GPG private key";
      Wants = [ "sops-nix.service" ];
      After = [ "sops-nix.service" ];
    };
    Service = {
      Type = "oneshot";
      Environment = "GNUPGHOME=${config.programs.gpg.homedir}";
      ExecStart = pkgs.writeScript "import-gpg-privkey" ''
        #!${lib.getExe pkgs.bash}
        if [ -z $SSH_CONNECTION ]; then
          ${lib.getExe config.programs.gpg.package} --import ${
            config.sops.secrets."pgp/0xB4E3D4801C49EC5E.asc".path
          }
          ${lib.getExe config.programs.gpg.package} --card-status
        fi
      '';
    };
    Install.WantedBy = [ "graphical-session-pre.target" ];
  };
  programs.fish.loginShellInit = lib.mkIf systemConfig.system.isGraphical "${lib.getExe' config.programs.gpg.package "gpgconf"} --launch gpg-agent";
}
