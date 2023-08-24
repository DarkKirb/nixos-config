{pkgs, ...}: {
  lspconfigPath = with pkgs; [
    nodePackages.bash-language-server
    clang
    clang-tools
    cmake-language-server
    nodePackages.dockerfile-language-server-nodejs
    elixir-ls
    gopls
    nodePackages.vscode-css-languageserver-bin
    nodePackages.vscode-html-languageserver-bin
    nodePackages.vscode-json-languageserver
    lua-language-server
    nil
    pyright
    nodePackages.typescript
    nodePackages.typescript-language-server
    nodePackages.vim-language-server

    haskell-language-server
    ltex-ls
    marksman
  ];
  lspconfig = {
    bashls = {};
    clangd = {};
    cmake = {};
    cssls = {};
    dockerls = {};
    elixirls.cmd = ["elixir-ls"];
    gopls = {};
    html = {};
    jsonls = {};
    lua_ls = {};
    nil_ls = {};
    pyright = {};
    tsserver = {};
    vimls = {};
    hls.filetypes = ["haskell" "lhaskell" "cabal"];
    ltex = {};
    marksman = {};
  };
}
