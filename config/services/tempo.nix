{lib, ...}: {
  services.tempo = {
    enable = true;
    settings = {
      server = {
        http_listen_address = "0.0.0.0";
        http_listen_port = 2144;
        graceful_shutdown_timeout = "10s";
      };
      distributor.receivers = {
        otlp.protocols = {
          grpc = {};
          http = {};
        };
        jaeger.protocols = {
          thrift_http = {};
          grpc = {};
          thrift_binary = {};
          thrift_compact = {};
        };
      };
      storage.trace = {
        backend = "local";
        wal.path = "/var/lib/tempo/wal";
        local.path = "/var/lib/tempo/blocks";
      };
    };
  };
  services.opentelemetry-collector.enable = lib.mkForce false;
  services.loki.enable = lib.mkForce false;
}
