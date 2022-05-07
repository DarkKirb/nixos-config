{ config, ... }: {
  imports = [
    ../../modules/hostapd.nix
  ];
  services.hostapd = {
    enable = true;
    countryCode = "DE";
    interface = "wlp6s0";
    ssid = "🦝";
    wpa = true;
    wpaPassphraseFile = config.sops.secrets."services/hostapd".path;
    extraConfig = ''
      utf8_ssid=1
      wmm_enabled=1
      ieee80211n=1
      wpa_pairwise=GCMP CCMP
    '';
  };
  sops.secrets."services/hostapd" = {
    restartUnits = [
      "hostapd.service"
    ];
  };
}
