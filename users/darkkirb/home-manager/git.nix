{ pkgs, systemConfig, ... }:
{
  programs.git = {
    enable = true;
    package = if systemConfig.system.isGraphical then pkgs.gitAndTools.gitFull else pkgs.git;
    lfs.enable = true;
    userEmail = "lotte@chir.rs";
    userName = "Charlotte 🦝 Deleńkec";
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
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";

      prompt = "enabled";

      aliases = {
        co = "pr checkout";
        pv = "pr view";
      };
    };
  };
}
