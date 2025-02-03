{
  nixos-config,
  ...
}:
{
  networking.hostName = "rainbow-resort";
  imports = [
    "${nixos-config}/config"
    ./disko.nix
    ./hardware.nix
    "${nixos-config}/services/chir-rs"
    "${nixos-config}/services/ollama.nix"
    "${nixos-config}/services/forgejo-runner"
  ];
  system.stateVersion = "24.11";
  home-manager.users.darkkirb.imports = [ ./home-manager.nix ];
}
