{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    clock24 = true;
    prefix = "C-a";
    sensibleOnTop = true;
    plugins = with pkgs.tmuxPlugins; [
      power-theme
      cpu
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
        '';
      }
    ];
    extraConfig = ''
      set-window-option -g automatic-rename on
      set-option -g set-titles on
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D
      bind -n S-Left previous-window
      bind -n S-Right next-window
      set -sg escape-time 0
      set -g mouse on
      set -g default-terminal "screen-256color"
    '';
  };
  programs.fish.shellInit = ''
    if status is-interactive
    and not set -q TMUX
    and set -q SSH_TTY
      tmux attach || tmux
    end
  '';
  programs.fzf.tmux.enableShellIntegration = true;
}
