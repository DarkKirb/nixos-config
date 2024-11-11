{ pkgs, config, ... }:
{
  accounts.contact.accounts.lotte = {
    khal = {
      enable = true;
      addresses = [ "lotte@chir.rs" ];
    };
    khard.enable = true;
    remote = {
      passwordCommand = [
        "${pkgs.coreutils}/bin/cat"
        config.sops.secrets."accounts/contact/accounts/lotte/remote/password".path
      ];
      type = "carddav";
      url = "https://contacts.zoho.eu/carddav/lotte@chir.rs/default/contacts";
      userName = "lotte@chir.rs";
      vdirsyncer.enable = true;
    };
  };
  accounts.calendar.basePath = "Data/contacts";
  sops.secrets."accounts/contact/accounts/lotte/remote/password".sopsFile = ./secrets.yaml;
}
