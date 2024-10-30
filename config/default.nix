{nixos-config, ...}: {
  imports = [
    "${nixos-config}/modules"
    "${nixos-config}/services/tailscale.nix"
    "${nixos-config}/services/openssh.nix"
    "${nixos-config}/users"
    ./systemd-boot.nix
  ];
  boot.initrd.systemd.enable = true;
}
