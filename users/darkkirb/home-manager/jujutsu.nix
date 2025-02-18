{ lib, pkgs, ... }:
{
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        email = "lotte@chir.rs";
        name = "Charlotte 🦝 Deleńkec";
      };
      signing = {
        behavior = "own";
        backend = "gpg";
        key = "B4E3D4801C49EC5E";
      };
      fix.tools.treefmt = {
        command = [ (lib.getExe pkgs.treefmt) ];
        patterns = [ "glob:**/*" ];
      };
      git.subprocess = true;
    };
  };
}
