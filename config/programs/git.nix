{pkgs, ...}: {
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
      diff = {
        tool = "kitty";
        guitool = "kitty.gui";
      };
      difftool = {
        prompt = false;
        trustExitCode = true;
        kitty.cmd = "${pkgs.kitty}/bin/kitty +kitten diff $LOCAL $REMOTE";
        "kitty.gui".cmd = "${pkgs.kitty}/bin/kitty ${pkgs.kitty}/bin/kitty +kitten diff $LOCAL $REMOTE";
      };
    };
  };
}
