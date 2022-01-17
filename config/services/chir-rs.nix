{ pkgs, ... } @ args: {
  systemd.services.chirrs = {
    enable = true;
    description = builtins.trace args "chir.rs";
    script = "${pkgs.chir-rs}/chir-rs-server";
    serviceConfig = {
      WorkingDirectory = pkgs.chir-rs;
      EnvironmentFile = "/run/secrets/services/chir.rs";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
