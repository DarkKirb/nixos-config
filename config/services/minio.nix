{ ... }: {
  services.minio = {
    enable = true;
    rootCredentialsFile = "/run/secrets/security/minio/credentials_file";
  };
  services.prometheus.exporters.minio = {
    enable = true;
  };
}
