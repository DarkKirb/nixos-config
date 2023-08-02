{pkgs, ...}: {
  services.uptime-kuma = {
    enable = true;
    settings = {
      PORT = "45566";
    };
  };
  services.caddy.virtualHosts."status.chir.rs" = {
    useACMEHost = "chir.rs";
    logFormat = pkgs.lib.mkForce "";
    extraConfig = ''
      import baseConfig

      reverse_proxy http://127.0.0.1:45566
    '';
  };
}
