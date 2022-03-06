{ pkgs, ... }:
let gitTemplate = pkgs.stdenv.mkDerivation {
  name = "git-template";
  src = pkgs.writeFile "dummy" "";
  nativeBuildInputs = with pkgs; with rust-binaries; [
    git
    mit-commit-msg
    mit-pre-commit
    mit-prepare-commit-msg
  ];
  buildPhase = "true";
  installPhase = ''
    git init $out
    ln -s $out/.git/hooks/commit-msg ${mit-commit-msg}/bin/mit-commit-msg
    ln -s $out/.git/hooks/pre-commit ${mit-pre-commit}/bin/mit-pre-commit
    ln -s $out/.git/hooks/prepare-commit-msg ${mit-prepare-commit-msg}/bin/mit-prepare-commit-msg
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
