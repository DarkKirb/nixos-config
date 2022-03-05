{ pkgs, ... }: {
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    lfs.enable = true;
    signing.signByDefault = true;
    signing.key = "AB2BD8DAF2E37122";
    userEmail = "lotte@chir.rs";
    userName = "Charlotte 🦝 Delenk";
  };
  home.packages = with pkgs.rust-binaries; [
    git-mit
    git-mit-config
    git-mit-install
    git-mit-relates-to
    mit-commit-message-lints
    mit-commit-msg
    mit-hook-test-helper
    mit-pre-commit
    mit-prepare-message-commit
  ];
}
