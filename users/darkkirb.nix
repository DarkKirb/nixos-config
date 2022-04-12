{ ... }: {
  users.users.root = {
    description = "Charlotte 🦝 Delenk";
    passwordFile = "/run/secrets-for-users/password/darkkirb";
  };
  sops.secrets."password/darkkirb" = {
    key = "darkkirb";
    sopsFile = ../secrets/password.yaml;
    neededForUsers = true;
  };
}
