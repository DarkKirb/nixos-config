{
  nixos-config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./configuration.nix
    "${nixos-config}/config"
  ];

  # Make it use predictable interface names starting with eth0
  boot.kernelParams = [ "net.ifnames=0" ];

  networking.useDHCP = true;
  isInstaller = true;

  environment.impermanence.enable = false;
  boot.initrd.systemd.enable = lib.mkForce false;
  home-manager.sharedModules = [ { home.persistence = lib.mkForce { }; } ];

  environment.systemPackages = [
    (pkgs.writeShellScriptBin "install-oracle-unattended" ''
      set -eux
      exec ${pkgs.disko}/bin/disko-install --flake "${nixos-config}#oracle" --disk main "${nixos-config.nixosConfigurations.thinkrac.config.disko.devices.disk.main.device}"
    '')
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIDXQlfvRUm/z6eP1EjsajIbMibkq9n+ymlbBi7NFiOuaAAAABHNzaDo= ssh:"
  ];
}
