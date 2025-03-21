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
    ../../services/kubernetes
  ];
  system.stateVersion = "24.11";
  home-manager.users.darkkirb.imports = [ ./home-manager.nix ];
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [ "olm-3.2.16" ];
}
