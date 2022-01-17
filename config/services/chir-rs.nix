{ pkgs, ... } @ args: {
  systemd.services.chirrs = {
    enable = true;
    description = builtins.trace args "chir.rs";
    script = "${chir-rs}/chir-rs-server";
    serviceConfig = {
      WorkingDirectory = chir-rs;
      EnvironmentFile = "/run/secrets/services/chir.rs";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
