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
  };
  sops.secrets."pgp/0xB4E3D4801C49EC5E.asc".sopsFile = ./privkey.yaml;
  home.activation.import-gpg-privkey =
    lib.hm.dag.entryAfter
      [
        "writeBoundary"
        "sops-nix"
        "importGpgKeys"
      ]
      ''
        run env GNUPGHOME=${config.programs.gpg.homedir} ${config.programs.gpg.package}/bin/gpg --import ${
          config.sops.secrets."pgp/0xB4E3D4801C49EC5E.asc".path
        }
      '';
}
