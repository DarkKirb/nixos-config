{ pkgs, config, ... }:
{
  accounts.calendar.accounts.lotte = {
    khal = {
      enable = true;
      addresses = [ "lotte@chir.rs" ];
    };
    primary = true;
    remote = {
      passwordCommand = [
        "${pkgs.coreutils}/bin/cat"
        config.sops.secrets."accounts/calendar/accounts/lotte/remote/password".path
      ];
      type = "caldav";
      url = "https://calendar.zoho.eu/caldav/423167e221264cf4af974b9faa0abc3b/events/";
      userName = "lotte@chir.rs";
      vdirsyncer.enable = true;
    };
  };
  accounts.calendar.basePath = "Data/.calendar";
  sops.secrets."accounts/calendar/accounts/lotte/remote/password".sopsFile = ./secrets.yaml;
}
