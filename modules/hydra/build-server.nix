{
  lib,
  config,
  nix-eval-jobs,
  system,
  ...
}:
with lib;
{
  options.hydra.buildServer.enable = mkEnableOption "Make this device a build server";
  imports = [
    {
      config.hydra.buildServer.enable =
        let
          buildServers = import ./build-server-list.nix;
        in
        mkDefault (any (t: t == config.networking.hostName) buildServers);
    }
  ];
  config = mkIf config.hydra.buildServer.enable {
    users.users.remote-build = {
      description = "Remote builder";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINN5Q/L2FyB3DIgdJRYnTGHW3naw5VQ9coOdwHYmv0aZ darkkirb@thinkrac"
      ];
    };
    nix.settings.trusted-users = [ "remote-build" ];
    environment.systemPackages =
      if system == "x86_64-linux" then [ nix-eval-jobs.packages.x86_64-linux.nix-eval-jobs ] else [ ];
  };
}
