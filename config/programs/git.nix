desktop: {pkgs, ...}: {
  programs.git = {
    enable = true;
    package =
      if desktop
      then pkgs.gitAndTools.gitFull
      else pkgs.git;
    lfs.enable = true;
    userEmail = "lotte@chir.rs";
    userName = "Charlotte 🦝 Delenk";
    extraConfig = {
      init.defaultBranch = "main";
      merge.conflictstyle = "diff3";
      push.autoSetupRemote = true;
      rerere.enabled = true;
    };
    delta.enable = true;
  };
}
