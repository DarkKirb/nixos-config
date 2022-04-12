{ ... }: {
  users.users.darkkirb = {
    createHome = true;
    description = "Charlotte 🦝 Delenk";
    extraGroups = [
      "wheel"
    ];
    group = "users";
    home = "/home/darkkirb";
    isNormalUser = true;
    uid = 1000;
    openssh.authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIDXQlfvRUm/z6eP1EjsajIbMibkq9n+ymlbBi7NFiOuaAAAABHNzaDo= ssh:"
    ];
    passwordFile = "/run/secrets-for-users/password/darkkirb";
  };
  sops.secrets."password/darkkirb" = {
    key = "darkkirb";
    sopsFile = ../secrets/password.yaml;
    neededForUsers = true;
  };
}
