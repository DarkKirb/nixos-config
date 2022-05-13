{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    lfs.enable = true;
    signing.signByDefault = true;
    signing.key = "AB2BD8DAF2E37122";
    userEmail = "lotte@chir.rs";
    userName = "Charlotte 🦝 Delenk";
    extraConfig = {
      init.defaultBranch = "main";
      merge.conflictstyle = "diff3";
    };
  };
}
