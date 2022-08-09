{ pkgs, ... }:

{
  # TODO: Don't let the runner inherit nix-neovim's PATH

  vim.g = {
    VimuxUseNearest = 0;
    VimuxHeight = "30";
    VimuxCloseOnExit = true;
  };

  vim.keybindings.keybindings."<leader>" = {
    # It's possible to also use vim-tmux-navigator's :TmuxNavigatePrevious
    # Not too keen on it yet though
    rr = { command = "<cmd>VimuxRunLastCommand<cr>"; label = "Rerun Command"; };
    rp = { command = "<cmd>VimuxPromptCommand<cr>"; label = "Prompt Command"; };

    ro = { command = "<cmd>VimuxOpenRunner<cr>"; label = "Open Runner"; };
    rq = { command = "<cmd>VimuxCloseRunner<cr>"; label = "Close Runner"; };

    ry = { command = "<cmd>VimuxInspectRunner<cr>"; label = "Copy Mode"; };
  };

  output.plugins = with pkgs.vimPlugins; [ vimux ];
}
