{ pkgs, systemConfig, ... }:
{
  programs.git = {
    enable = true;
    package = if systemConfig.isGraphical then pkgs.gitAndTools.gitFull else pkgs.git;
    lfs.enable = true;
    userEmail = "lotte@chir.rs";
    userName = "Charlotte 🦝 Delenk";
    extraConfig = {
      init.defaultBranch = "main";
      merge.conflictstyle = "diff3";
      push.autoSetupRemote = true;
      rerere.enabled = true;
      user.signingkey = "AB2BD8DAF2E37122";
      commit.gpgsign = true;
    };
    delta.enable = true;
  };
}
