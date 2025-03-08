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
    ../../services/forgejo-runner
    ../../services/jellyfin.nix
  ];
  system.stateVersion = "24.11";
  home-manager.users.darkkirb.imports = [ ./home-manager.nix ];
  nixpkgs.config.allowUnfree = true;
}
