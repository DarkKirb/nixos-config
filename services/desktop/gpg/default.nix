{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.gpg = {
    enable = true;
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
    enable = true;
    pinentryPackage = pkgs.pinentry-qt;
    enableExtraSocket = true;
  };
  services.ssh-agent.enable = true;
  sops.secrets."pgp/0xB4E3D4801C49EC5E.asc".sopsFile = ./privkey.yaml;
  systemd.user.services.import-gpg-privkey = {
    Unit = {
      Description = "Imports the GPG private key";
      Wants = [ "sops-nix.service" ];
      After = [ "sops-nix.service" ];
    };
    Service = {
      Type = "oneshot";
      Environment = "GNUPGHOME=${config.programs.gpg.homedir}";
      ExecStart = pkgs.writeScript "import-gpg-privkey" ''
        #!${pkgs.bash}/bin/bash
        ${config.programs.gpg.package}/bin/gpg --import ${
          config.sops.secrets."pgp/0xB4E3D4801C49EC5E.asc".path
        }
        ${config.programs.gpg.package}/bin/gpg --card-status
      '';
    };
    Install.WantedBy = [ "graphical-session-pre.target" ];
  };
  programs.fish.loginShellInit = "gpgconf --launch gpg-agent";
}
