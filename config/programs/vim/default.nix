desktop: {
  pkgs,
  nix-neovim,
  ...
}: let
  myNeovim = nix-neovim.buildNeovim {
    configuration = import ./configuration.nix desktop;
    inherit pkgs;
  };
in {
  home.packages = [
    myNeovim
  ];

  systemd.user.tmpfiles.rules = [
    "d %h/.cache/nvim/undo-files 0700 - -  mM:1w -"
    "d %h/.cache/nvim/swap-files 0700 - -  mM:1w -"
    "d %h/.cache/nvim/backup-files 0700 - -  mM:1w -"
  ];
}
