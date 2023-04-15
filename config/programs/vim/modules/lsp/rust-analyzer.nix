{pkgs, ...}: {
  lspconfigPath = with pkgs; [
    rust-analyzer
  ];
  lspconfig = {
    rust_analyzer = {};
  };
}
