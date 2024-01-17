desktop: {pkgs, ...}: {
  programs.git = {
    enable = true;
    package =
      if desktop
      then pkgs.gitAndTools.gitFull
      else pkgs.git;
    lfs.enable = true;
    signing.signByDefault = true;
    signing.key = "AB2BD8DAF2E37122";
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
