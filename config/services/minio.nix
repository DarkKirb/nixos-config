{ ... }: {
  services.minio = {
    enable = true;
    rootCredentialsFile = "/run/secrets/security/minio/credentials_file";
  };
  services.prometheus.exporters.minio = {
    enable = true;
  };
  networking.firewall.interfaces."wg0".allowedTCPPorts = [ 9000 9001 ];
}
