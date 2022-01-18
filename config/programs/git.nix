{ pkgs, ... }: {
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    lfs.enable = true;
    signing.signByDefault = true;
    userEmail = "lotte@chir.rs";
    userName = "Charlotte 🦝 Delenk";
  };
}