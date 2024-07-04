{pkgs, ...}: {
  lspconfigPath = with pkgs; [
    nodePackages.bash-language-server
    clang
    clang-tools
    cmake-language-server
    nodePackages.dockerfile-language-server-nodejs
    elixir-ls
    gopls
    lua-language-server
    nil
    pyright
    nodePackages.typescript
    nodePackages.typescript-language-server
    nodePackages.vim-language-server
    ltex-ls
    marksman
  ];
  lspconfig = {
    bashls = {};
    clangd = {};
    cmake = {};
    dockerls = {};
    elixirls.cmd = ["elixir-ls"];
    gopls = {};
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
