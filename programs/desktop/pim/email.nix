{
  pkgs,
  config,
  lib,
  ...
}:
{
  accounts.email.accounts.lotte = {
    address = "lotte@chir.rs";
    gpg = {
      encryptByDefault = true;
      key = "B4E3D4801C49EC5E";
      signByDefault = true;
    };
    imap = {
      host = "imappro.zoho.eu";
      port = 993;
    };
    passwordCommand = [
      "${lib.getExe' pkgs.coreutils "cat"}"
      config.sops.secrets."accounts/email/accounts/lotte/password".path
    ];
    realName = "Charlotte 🦝 Deleńkec";
    smtp = {
      host = "smtppro.zoho.eu";
      port = 465;
    };
    thunderbird.enable = true;
    userName = "lotte@chir.rs";
    primary = true;
  };
  sops.secrets."accounts/email/accounts/lotte/password".sopsFile = ./secrets.yaml;
  programs.thunderbird = {
    enable = true;
    package = pkgs.thunderbird-latest;
    profiles.default = {
      isDefault = true;
      withExternalGnupg = true;
    };
  };
}
