{ config, ... }: {
  users.users.darkkirb = {
    createHome = true;
    description = "Charlotte 🦝 Delenk";
    extraGroups = [
      "wheel"
      "input"
    ];
    group = "users";
    home = "/home/darkkirb";
    isNormalUser = true;
    uid = 1000;
    openssh.authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIDXQlfvRUm/z6eP1EjsajIbMibkq9n+ymlbBi7NFiOuaAAAABHNzaDo= ssh:"
    ];
    passwordFile = config.sops.secrets."password/darkkirb".path;
  };
  sops.secrets."email/lotte@chir.rs" = { owner = "darkkirb"; };
  sops.secrets."email/mdelenk@hs-mittweida.de" = { owner = "darkkirb"; };
  sops.secrets."password/darkkirb" = {
    neededForUsers = true;
  };
  services.postgresql.ensureDatabases = [ "darkkirb" ];
  services.postgresql.ensureUsers = [{
    name = "darkkirb";
    ensurePermissions = { "DATABASE darkkirb" = "ALL PRIVILEGES"; };
  }];
}
