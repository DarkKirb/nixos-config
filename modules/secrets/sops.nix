{
  sops-nix,
  config,
  ...
}: {
  imports = [
    "${sops-nix}/modules/sops"
  ];
  sops.age = {
    sshKeyPaths = [
      "/etc/ssh/ssh_host_ed25519_key"
    ];
  };
}
