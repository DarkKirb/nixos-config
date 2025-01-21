{ pkgs, lib, ... }:
{
  programs.fish.enable = true;
  home-manager.users.root.imports = [
    ./home-manager.nix
  ];
  home-manager.users.darkkirb.imports = [
    ./home-manager.nix
  ];
  programs.bash.interactiveShellInit = ''
    for user in root darkkirb; do
      if [[ $USER == $user ]]; then
        if [[ $(${lib.getExe' pkgs.procps "ps"} --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
        then
          shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
          exec ${lib.getExe pkgs.fish} $LOGIN_OPTION
        fi
      fi
    done
  '';
}
