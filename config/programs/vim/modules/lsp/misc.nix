{pkgs, ...}: {
  lspconfigPath = with pkgs; [
    nodePackages.bash-language-server
    clang
    clang-tools
    cmake-language-server
    dhall-lsp-server
    nodePackages.dockerfile-language-server-nodejs
    elixir-ls
    gopls
    haskell-language-server
    nodePackages.vscode-css-languageserver-bin
    nodePackages.vscode-html-languageserver-bin
    nodePackages.vscode-json-languageserver
    ltex-ls
    lua-language-server
    marksman
    nil
    pyright
    nodePackages.typescript
    nodePackages.typescript-language-server
    nodePackages.vim-language-server
  ];
  lspconfig = {
    bashls = {};
    clangd = {};
    cmake = {};
    cssls = {};
    dhall_lsp_server = {};
    dockerls = {};
    elixirls.cmd = ["elixir-ls"];
    gopls = {};
    hls.filetypes = ["haskell" "lhaskell" "cabal"];
    html = {};
    jsonls = {};
    ltex = {};
    lua_ls = {};
    marksman = {};
    nil_ls = {};
    pyright = {};
    tsserver = {};
    vimls = {};
  };
}
