{...}: {
  services.heisenbridge = {
    port = 30435;
    owner = "@lotte:chir.rs";
    homeserver = "https://matrix.int.chir.rs";
    enable = true;
  };
  services.matrix-synapse.settings.app_service_config_files = ["/var/lib/heisenbridge/registration.yaml"];
}
