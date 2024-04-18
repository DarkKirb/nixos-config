{config, ...}: {
  networking = {
    bridges.containers.interfaces = ["container-root"];
    interfaces = {
      container-root = {
        virtual = true;
      };
      containers = {
        ipv6.addresses = [
          {
            address = "fc00::1";
            prefixLength = 64;
          }
        ];
      };
    };
  };
}
