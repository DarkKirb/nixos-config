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
      Requires = [ "gpg-agent-extra.socket" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = pkgs.writeScript "link-gpg" ''
        #!${pkgs.bash}/bin/sh
        stream_path=$(${pkgs.systemd}/bin/systemd show --user gpg-agent-extra.socket --property Listen | ${pkgs.coreutils}/bin/cut -d'=' -f 2- | ${pkgs.coreutils}/bin/cut -d' ' -f 1)
        ${pkgs.coreutils}/bin/mkdir -p $HOME/.local/state/gnupg
        ${pkgs.coreutils}/bin/ln -Tfs $stream_path %h/.local/state/gnupg
      '';
      ExecStop = "${pkgs.coreutils}/bin/rm -rf $HOME/.local/state/gnupg";
      RemainAfterExit = true;
    };
    Install.WantedBy = [ "default.target" ];
  };
}
