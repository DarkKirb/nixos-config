{ ... }: {
  services.elasticsearch = {
    enable = true;
    cluster_name = "chir-rs";
  };
}
