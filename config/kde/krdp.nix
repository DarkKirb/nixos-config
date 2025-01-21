{ config, ... }:
{
  programs.plasma.configFile.krdpserverrc.General = {
    Autostart = true;
    Certificate = config.sops.secrets.".local/share/krdpserver/krdp.crt".path;
    CertificateKey = config.sops.secrets.".local/share/krdpserver/krdp.key".path;
    Users = "darkkirb";
  };
  sops.secrets.".local/share/krdpserver/krdp.key".sopsFile = ./krdp.yaml;
  sops.secrets.".local/share/krdpserver/krdp.crt".sopsFile = ./krdp.yaml;
}
