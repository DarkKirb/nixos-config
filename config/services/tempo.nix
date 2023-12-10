{lib, ...}: {
  services.tempo = {
    enable = true;
    settings = {
      server = {
        http_listen_address = "0.0.0.0";
        http_listen_port = 2144;
        graceful_shutdown_timeout = "10s";
      };
      distrubtor.receiver = {
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
      storage.trace.backend = "local";
    };
  };
  services.opentelemetry-collector.enable = lib.mkForce false;
}
