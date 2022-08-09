# Largely copied from a great blog post:
# https://sharksforarms.dev/posts/neovim-rust/
{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  vim.opt = {
    completeopt = "menuone,noinsert,noselect";

    # Set updatetime for CursorHold
    # 300ms of no cursor movement to trigger CursorHold
    updatetime = 300;

    # have a fixed column for the diagnostics to appear in
    # this removes the jitter when warnings/errors flow in
    signcolumn = "yes";
  };

  vim.keybindings.keybindings-shortened = {
    "K" = {command = "<cmd>lua vim.lsp.buf.hover()<cr>";};
  };

  vim.g.lightline.component_expand.lsp_status = "LspStatus";
  vim.g.lightline.active.right = mkAfter [["lsp_status"]];

  # https://discourse.nixos.org/t/rust-src-not-found-and-other-misadventures-of-developing-rust-on-nixos/11570/2
  output.makeWrapper = "--set RUST_SRC_PATH ${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";

  output.config_file = ''
    set shortmess+=c

    lua <<EOF
    -- lsp_status
    local lsp_status = require('lsp-status')
    lsp_status.config({
      status_symbol = "",
      current_function = false,
      -- indicator_errors = 'E',
      -- indicator_warnings = 'W',
      -- indicator_info = 'i',
      -- indicator_hint = '?',
      -- indicator_ok = '好',
    })
    lsp_status.register_progress()

    function on_attach(client)
      lsp_status.on_attach(client)

      -- Disable formatting for all LS, let null-ls handle this
      client.resolved_capabilities.document_formatting = false
      client.resolved_capabilities.document_range_formatting = false
    end

    -- Setup all LSPs
    local nvim_lsp = require'lspconfig'
    local servers = {'rust_analyzer', 'rnix', 'clangd', 'pyright'}
    for _, s in ipairs(servers) do
      nvim_lsp[s].setup({
        on_attach = on_attach,
        capabilities = lsp_status.capabilities,
      })
    end

    -- handle diagnostics
    -- https://github.com/nvim-lua/diagnostic-nvim/issues/73
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = true,
        signs = true,
        update_in_insert = false,
      }
    )
    EOF

    " Statusline
    function! LspStatus() abort
      if luaeval('#vim.lsp.buf_get_clients() > 0')
        return luaeval("require('lsp-status').status()")
      endif
      return ""
    endfunction
    autocmd InsertLeave,BufEnter,BufWritePost * call lightline#update()
    autocmd User LspDiagnosticsChanged call lightline#update()

    " Show diagnostic popup on cursor hold
    autocmd CursorHold * lua vim.diagnostic.open_float()

    " Enable type inlay hints
    " FIXME: https://github.com/nvim-lua/lsp_extensions.nvim/issues/30
    " autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *
    " \ lua require'lsp_extensions'.inlay_hints{ prefix = "", highlight = "Comment" }
  '';

  output.plugins = with pkgs.vimPlugins; [
    nvim-lspconfig
    lsp_extensions-nvim
    lsp-status-nvim
  ];

  output.path.path = with pkgs; [
    # Rust
    cargo
    rustc
    rust-analyzer

    # Nix
    rnix-lsp

    # C++
    clang-tools

    # Python
    (writeScriptBin "pyright-langserver" ''
      # pyright has a symlinked `./bin` which breaks Nix's `symlinkJoin`
      # This wrapper script fixes that.

      ${pyright}/bin/pyright-langserver $@
    '')
  ];
}
