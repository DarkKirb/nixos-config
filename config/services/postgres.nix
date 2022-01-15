{ lib, ... }: {
  services.postgres = {
    enable = true;
    enableTCPIP = true;
    authentication = [
      "host  all all fd0d:a262:1fa6:e621::/64 md5;"
    ];
  };
}
