{ config, ... }:
{
  sops.secrets.".config/sops/age/keys.txt" = {
    sopsFile = ./keys.yaml;
    path = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
  };
}
