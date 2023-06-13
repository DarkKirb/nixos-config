{pkgs, ...}: {
  lspconfigPath = with pkgs;
    [
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
      lua-language-server
      nil
      pyright
      nodePackages.typescript
      nodePackages.typescript-language-server
      nodePackages.vim-language-server
    ]
    ++ (
      if pkgs.system != "riscv64-linux"
      then with pkgs; [ltex-ls marksman]
      else []
    );
  lspconfig =
    {
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
      lua_ls = {};
      nil_ls = {};
      pyright = {};
      tsserver = {};
      vimls = {};
    }
    // (
      if pkgs.system != "riscv64-linux"
      then {
        ltex = {};
        marksman = {};
      }
      else {}
    );
}
