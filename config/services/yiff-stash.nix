{
  config,
  system,
  pkgs,
  ...
}: {
  users.users.yiffstash = {
    group = "yiffstash";
    isSystemUser = true;
  };
  users.groups.yiffstash = {};

  systemd.services.yiffstash = {
    enable = true;
    description = "Post yiff to telegram";
    serviceConfig = {
      ExecStart = "/bin/sh ${pkgs.yiffstash}";
      User = "yiffstash";
      Group = "yiffstash";
      Type = "oneshot";
    };
  };
  systemd.timers.yiffstash = {
    enable = true;
    description = "Post yiff to telegram";
    requires = ["yiffstash.service"];
    wantedBy = ["multi-user.target"];
    timerConfig = {
      OnUnitActiveSec = "30m";
      RandomizedDelaySec = "1h";
    };
  };
  sops.secrets."caroline/yiffstash/bot-token".owner = "yiffstash";
}
