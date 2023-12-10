{config, ...}: {
  services.opentelemetry-collector = {
    enable = true;
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
            exporters = ["otlp"];
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
  services.prometheus.scrapeConfigs = [
    {
      job_name = "opentelemetry-collector";
      static_configs = [
        {
          targets = [
            "127.0.0.1:63174"
          ];
        }
      ];
    }
  ];
}
