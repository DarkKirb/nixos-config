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
      user.signingkey = "B4E3D4801C49EC5E";
      commit.gpgsign = true;
    };
    delta.enable = true;
  };
}
