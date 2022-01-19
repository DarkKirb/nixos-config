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
  };
  sops.secrets."email/darkkirb@darkkirb.de" = { owner = "darkkirb"; };
  sops.secrets."email/lotte@chir.rs" = { owner = "darkkirb"; };
  sops.secrets."email/mdelenk@hs-mittweida.de" = { owner = "darkkirb"; };
}
