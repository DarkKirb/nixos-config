{ pkgs, config, ... }:
{
  services.ssh-agent.enable = true;
  systemd.user.services.import-ssh-key = {
    Unit = {
      Description = "Imports the ssh key";
      Wants = [ "ssh-agent.service" ];
      After = [ "ssh-agent.service" ];
      PartOf = [ "ssh-agent.service" ];
    };
    Service = {
      Type = "oneshot";
      RemainAfterExit = "yes";
      ExecStart = ''${pkgs.openssh}/bin/ssh-add ${config.sops.secrets.".ssh/builder_id_ed25519".path}'';
    };
    Install.WantedBy = [ "default.target" ];
  };
}
