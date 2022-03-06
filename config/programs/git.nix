{ pkgs, ... }:
let gitTemplate = pkgs.stdenv.mkDerivation {
  name = "git-template";
  src = ./.;
  nativeBuildInputs = with pkgs; with rust-binaries; [
    git
    mit-commit-msg
    mit-pre-commit
    mit-prepare-commit-msg
  ];
  buildPhase = "true";
  installPhase = with pkgs; with rust-binaries; ''
    git init $out --bare
    cd $out
    git branch -m main
    ln -s ${mit-commit-msg}/bin/mit-commit-msg $out/hooks/commit-msg
    ln -s ${mit-pre-commit}/bin/mit-pre-commit $out/hooks/pre-commit
    ln -s ${mit-prepare-commit-msg}/bin/mit-prepare-commit-msg $out/hooks/prepare-commit-msg
  '';
};
in
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
      init.templatedir = "${gitTemplate}";
    };
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
    mit-prepare-commit-msg
  ];
}
