{ config, ... }: {
  imports = [
    ../../modules/hostapd.nix
  ];
  services.hostapd = {
    enable = true;
    countryCode = "DE";
    interface = "wlp6s0";
    ssid = "racc";
    wpa = true;
    wpaPassphraseFile = config.sops.secrets."services/hostapd".path;
    extraConfig = ''
      wmm_enabled=1
      ieee80211n=1
    '';
  };
  sops.secrets."services/hostapd" = {
    restartUnits = [
      "hostapd.service"
    ];
  };
}
