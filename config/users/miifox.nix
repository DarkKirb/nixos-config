{
  pkgs,
  nix-packages,
  system,
  ...
}: {
  users.users.miifox = {
    createHome = true;
    description = "Miifox";
    group = "users";
    home = "/home/miifox";
    isNormalUser = true;
    uid = 1001;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDDIqSXWTE+zpq+DjgZbWI2i+9++SHCEorrfcNT7oDgeah1oGqg84X3f7hIov7FtNYExFj+kaYW7GOOOV9KwwB6W5adfORWvP6domwXdLutDOnkfAXCNAQBBXDRMrAHS9x089xdFJ0+FTVbB8a4QN9DG82uxGPSoMGwZfloYM0/SYahc5x3I2zpMi9PxJJzhrnmSXJx2gMYMkEoMZBxWdlXD/ge192ejMDQ/f4idW7humK9F6TG7j7u5pqUmN/WqZVg1f2mltjUFjRWn+gIDmEpgfqJ3LXQHu90vAWpXVYMsPqHc8A6+Y29YB9BuCflC4gSwKZqTHVp9oaMYJIBEw0xayK5TgsC0EliX7WQK7KacjGHhQPhP/igT+/wTC1I+gdyjOGloVVFOjWJLbpW+9C/Xp/Oy8zcH7YPj9vO8Sc5jZhuRxWgH7vUI9Nl+wjfcbKRx3ihS3HP7zenN9ATr0gO1Cj7yWKn0Mhr6an3hMDFbAA9ppiTr9JC4wvUIrurHiE= caroline the husky@Huskydev"
    ];
  };
  home-manager.users.miifox = import ../home-manager/miifox.nix;
  systemd.slices."user-1001".sliceConfig = {
    CPUQuota = "100%";
    MemoryHigh = "1G";
    MemoryMax = "1.1G";
  };
  services.postgresql.ensureDatabases = ["miifox"];
  services.postgresql.ensureUsers = [
    {
      name = "miifox";
      ensurePermissions = {"DATABASE miifox" = "ALL PRIVILEGES";};
    }
  ];
  services.caddy.virtualHosts."miifox.net" = {
    useACMEHost = "miifox.net";
    logFormat = pkgs.lib.mkForce "";
    extraConfig = ''
      import baseConfig

      root * ${nix-packages.packages.${system}.miifox-net}
      file_server
    '';
  };
}
