{
  config,
  lib,
  ...
}:
{
  sops.age.sshKeyPaths = lib.mkIf config.environment.impermanence.enable [
    "/persistent/etc/ssh/ssh_host_ed25519_key"
  ];
}
