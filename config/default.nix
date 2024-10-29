{nixos-config, ...}: {
  imports = [
    "${nixos-config}/modules"
    "${nixos-config}/services/tailscale.nix"
    ./systemd-boot.nix
  ];
}
