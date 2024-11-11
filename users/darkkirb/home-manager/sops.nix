{ config, ... }:
{
  sops.secrets.".config/sops/age/keys.txt" = {
    sopsFile = ./keys.txt;
    path = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
  };
}
