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
    enableSshSupport = true;
    pinentryPackage = pkgs.pinentry-qt;
    enableExtraSocket = true;
  };
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
  systemd.user.services.link-gnupg-sockets = {
    Unit = {
      Description = "link gnupg sockets from /run to /home";
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.coreutils}/bin/ln -Tfs /run/user/%U/gnupg %h/.local/state/gnupg";
      ExecStop = "${pkgs.coreutils}/bin/rm $HOME/.local/state/gnupg";
      RemainAfterExit = true;
    };
    Install.WantedBy = [ "default.target" ];
  };
}
