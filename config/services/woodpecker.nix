{
  config,
  pkgs,
  lib,
  ...
}: {
  services.woodpecker-server = {
    enable = true;
    environment = {
      WOODPECKER_SERVER_HOST = "woodpecker.chir.rs";
      WOODPECKER_SERVER_PROTO = "https";
      WOODPECKER_SERVER_PORT = ":47927";
    };
    environmentFile = config.sops.secrets."services/woodpecker".path;
  };
  sops.secrets."services/woodpecker" = {};
  services.caddy.virtualHosts."woodpecker.int.chir.rs" = {
    useACMEHost = "int.chir.rs";
    logFormat = pkgs.lib.mkForce "";
    extraConfig = ''
      import baseConfig
      reverse_proxy http://127.0.0.1:47927
    '';
  };
}
