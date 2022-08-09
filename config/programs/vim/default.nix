{
  pkgs,
  nix-neovim,
  ...
}: let
  myNeovim = nix-neovim.buildNeovim {
    configuration = ./configuration.nix;
    inherit pkgs;
  };
in {
  home.packages = [
    myNeovim
  ];

  systemd.user.tmpfiles.rules = [
    "d %h/.cache/nvim/undo-files 0700 %u %g  mM:1d -"
  ];
}
