{config, ...}: {
  users.users.darkkirb = {
    createHome = true;
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIDXQlfvRUm/z6eP1EjsajIbMibkq9n+ymlbBi7NFiOuaAAAABHNzaDo= ssh:"
    ];
    hashedPasswordFile = config.sops.secrets."users/users/darkkirb/hashedPassword".path;
    extraGroups = ["wheel"];
  };
  sops.secrets."users/users/darkkirb/hashedPassword" = {
    neededForUsers = true;
    sopsFile = ./system.yaml;
  };
  sops.secrets."users/users/darkkirb/age-key" = {
    owner = "darkkirb";
    sopsFile = ./system.yaml;
  };
  home-manager.users.darkkirb.sops.age.keyFile = config.sops.secrets."users/users/darkkirb/age-key".path;
  home-manager.users.darkkirb.home.persistence.default.directories = ["sources"];
  environment.impermanence.users = ["darkkirb"];
}
