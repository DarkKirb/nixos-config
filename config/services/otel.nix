{
  services.opentelemetry-collector = {
    enable = true;
    settings = {
      receivers = {
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
      processors.batch = {};
      exporters = {
        "otlp".endpoint = "nas.int.chir.rs:4317";
      };
    };
  };
}
