{ pkgs, ... }: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = (with pkgs.vscode-extensions; [
      arrterian.nix-env-selector
      bbenoist.nix
      eamodio.gitlens
      github.copilot
      jnoortheen.nix-ide
      matklad.rust-analyzer
      ms-vscode-remote.remote-ssh
      serayuzgur.crates
      tamasfe.even-better-toml
      ritwickdey.liveserver
      vadimcn.vscode-lldb
      vscodevim.vim
      yzhang.markdown-all-in-one
    ]) ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [{
      name = "rust-doc-viewer";
      publisher = "jscearcy";
      version = "2.0.1";
      sha256 = "sha256-bVWM3RlcXY0+fACKrOtq63dHo0neyaw/TuhUxwCxeYs=";
    }
    {
      name = "cargo";
      publisher = "panicbit";
      version = "0.2.3";
      sha256 = "sha256-B0oLZE8wtygTaUX9/qOBg9lJAjUUg2i7B2rfSWJerEU=";
    }
    {
      name = "vscode-rust-test-adapter";
      publisher = "swellaby";
      version = "0.11.0";
      sha256 = "sha256-IgfcIRF54JXm9l2vVjf7lFJOVSI0CDgDjQT+Hw6FO4Q=";
    }
    {
      name = "discord-vscode";
      publisher = "icrawl";
      version = "5.8.0";
      sha256 = "sha256-IU/looiu6tluAp8u6MeSNCd7B8SSMZ6CEZ64mMsTNmU=";
    }];
  };
}
