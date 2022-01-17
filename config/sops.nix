{ config, ... }:
{
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.defaultSopsFile = ../secrets + "/${config.networking.hostName}/secrets.yaml";
  sops.secrets."network/wireguard/privkey" = { };
  sops.secrets."security/acme/dns" = { };
  sops.secrets."security/restic/password" = { };
  sops.secrets."security/minio/credentials_file" = { };
  sops.secrets."services/gitea.nix" = { };
  sops.secrets."services/minio.nix" = { };
}
