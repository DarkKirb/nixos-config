{ config, ... }:
{
  programs.plasma.configFile.krdpserverrc.General = {
    Autostart = true;
    Certificate = config.sops.secrets.".local/share/krdpserver/krdp.crt".file;
    CertificateKey = config.sops.secrets.".local/share/krdpserver/krdp.key".file;
    Users = "darkkirb";
  };
  sops.secrets.".local/share/krdpserver/krdp.key".sopsFile = ./krdp.yaml;
  sops.secrets.".local/share/krdpserver/krdp.crt".sopsFile = ./krdp.yaml;
}
