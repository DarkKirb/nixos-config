{ pkgs, ... }: {
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    lfs.enable = true;
    signing.signByDefault = true;
    signing.key = "206DA5E1DA0904B6EE4916BA3CEF5DDA915AECB0";
    userEmail = "lotte@chir.rs";
    userName = "Charlotte 🦝 Delenk";
  };
}