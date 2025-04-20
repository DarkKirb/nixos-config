{
  ...
}:
{
  networking.hostName = "rainbow-resort";
  imports = [
    ../../config
    ./disko.nix
    ./hardware.nix
    ../../services/chir-rs
    ../../services/ollama.nix
    ../../services/jellyfin.nix
    ../../services/yiffstash
    ../../services/renovate
    ../../services/hydra
  ];
  system.stateVersion = "24.11";
  home-manager.users.darkkirb.imports = [ ./home-manager.nix ];
}
