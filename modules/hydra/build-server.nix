{
  lib,
  config,
  ...
}:
with lib; {
  options.hydra.buildServer.enable = mkEnableOption "Make this device a build server";
  config.hydra.buildServer.enable = let
    buildServers = import ./build-server-list.nix;
  in
    mkDefault (any (t: t == config.networking.hostName) buildServers);
  config.users.users.remote-build = mkIf config.hydra.buildServer.enable {
    description = "Remote builder";
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINN5Q/L2FyB3DIgdJRYnTGHW3naw5VQ9coOdwHYmv0aZ darkkirb@thinkrac"
    ];
  };
}
