{
  nixos-config,
  config,
  lib,
  ...
}: {
  users.users.root = {
    createHome = true;
    openssh.authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIDXQlfvRUm/z6eP1EjsajIbMibkq9n+ymlbBi7NFiOuaAAAABHNzaDo= ssh:"
    ];
    hashedPasswordFile = config.sops.secrets."users/users/root/hashedPassword".path;
  };
  sops.secrets."users/users/root/hashedPassword" = {
    neededForUsers = true;
    sopsFile = ./system.yaml;
  };
  sops.secrets.".ssh/builder_id_ed25519" = {
    mode = "600";
    sopsFile = "${nixos-config}/programs/ssh/shared-keys.yaml";
  };
  sops.secrets.".ssh/id_ed25519_sk" = {
    mode = "600";
    sopsFile = "${nixos-config}/programs/ssh/shared-keys.yaml";
  };
  home-manager.users.root.sops.secrets = lib.mkForce {};
  environment.impermanence.users = ["root"];
}
