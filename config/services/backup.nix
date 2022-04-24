{ ... }: {
  users.users.backup = {
    description = "Backup user";
    home = "/backup";
    isSystemUser = true;
    openssh.authorizedKeys.keys = [

    ];
    group = "backup";
  };
  users.groups.backup = { };
}
