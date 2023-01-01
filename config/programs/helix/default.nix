desktop: {
  system,
  pkgs,
  ...
}: {
  imports =
    if desktop
    then [
      ./languages.nix
    ]
    else [];
  home.packages = [
    pkgs.wl-clipboard
    pkgs.xsel
  ];
  programs.helix = {
    enable = true;
    settings = {
      editor = {
        line-number = "relative";
        cursorline = true;
        color-modes = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        indent-guides.render = true;
      };
    };
  };
}
