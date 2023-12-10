{
  config,
  pkgs,
  ...
}: {
  services.opentelemetry-collector = {
    enable = true;
    package = pkgs.opentelemetry-collector-contrib;
    settings = {
      receivers = {
        otlp.protocols = {
          grpc = {};
          http = {};
        };
      };
      processors.batch = {};
      exporters = {
        "otlp".endpoint = "nas.int.chir.rs:4317";
        otlp.tls.insecure = true;
        loki = {
          endpoint = "https://nas.int.chir.rs:3100/loki/api/v1/push";
        };
      };
      extensions = {
        zpages = {};
      };
      service = {
        extensions = ["zpages"];
        pipelines = {
          traces = {
            receivers = ["otlp"];
            processors = ["batch"];
            exporters = ["otlp"];
          };
          metrics = {
            receivers = ["otlp"];
            processors = ["batch"];
            exporters = ["otlp"];
          };
          logs = {
            receivers = ["otlp"];
            processors = ["batch"];
            exporters = ["loki"];
          };
        };
        telemetry = {
          logs.level = "DEBUG";
          logs.initial_fields.service = config.networking.hostName;
          metrics = {
            level = "detailed";
            address = "127.0.0.1:63174";
          };
        };
      };
    };
  };
}
