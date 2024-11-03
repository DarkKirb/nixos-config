{pkgs, ...}: {
  programs.fish.enable = true;
  home-manager.users.root.imports = [
    ./home-manager.nix
  ];
  programs.bash.interactiveShellInit = ''
    for user in root; do
      if [[ $USER == $user ]]; then
        if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
        then
          shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
          exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
        fi
      fi
    done
  '';
}
