{ ... }: {
  users.users.root = {
    passwordFile = "/run/secrets-for-users/password/root";
  };
  sops.secrets."password/root" = {
    key = "root";
    sopsFile = ../secrets/password.yaml;
    neededForUsers = true;
  };
}
