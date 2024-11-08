{systemConfig, ...}: {
  services.syncthing = {
    enable = true;
    tray.enable = true;
  };

  sops.secrets.".local/share/syncthing/cert.pem" = {
    sopsFile = ./${systemConfig.networking.hostName}.yaml;
    path = "${config.xdg.dataHome}/syncthing/cert.pem";
  };
  sops.secrets.".local/share/syncthing/https-cert.pem" = {
    sopsFile = ./${systemConfig.networking.hostName}.yaml;
    path = "${config.xdg.dataHome}/syncthing/https-cert.pem";
  };
  sops.secrets.".local/share/syncthing/key.pem" = {
    sopsFile = ./${systemConfig.networking.hostName}.yaml;
    path = "${config.xdg.dataHome}/syncthing/key.pem";
  };
  sops.secrets.".local/share/syncthing/https-key.pem" = {
    sopsFile = ./${systemConfig.networking.hostName}.yaml;
    path = "${config.xdg.dataHome}/syncthing/https-key.pem";
  };
  home.persistence.default.directories = ["${config.xdg.dataHome}/syncthing"];
}
