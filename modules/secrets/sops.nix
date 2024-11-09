{
  sops-nix,
  config,
  ...
}:
{
  imports = [
    "${sops-nix}/modules/sops"
  ];
  sops.age = {
    sshKeyPaths = [
      "/persistent/etc/ssh/ssh_host_ed25519_key"
    ];
  };
}
