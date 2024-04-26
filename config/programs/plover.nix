{
  lib,
  pkgs,
  system,
  emily-modifiers,
  emily-symbols,
  ...
}: let
  plover-env =
    (pkgs.plover.pythonModule.withPackages (_:
      with pkgs; [
        plover
        plover-plugins-manager
        plover-plugin-emoji
        plover-plugin-tapey-tape
        plover-plugin-yaml-dictionary
        plover-plugin-rkb1-hid
        plover-plugin-python-dictionary
        plover-plugin-stenotype-extended
        plover-plugin-dotool-output
        plover-plugin-lapwing-aio
      ]))
    .overrideDerivation (super: {
      nativeBuildInputs = super.nativeBuildInputs or [] ++ [pkgs.qt5.wrapQtAppsHook];
      postBuild =
        super.postBuild
        + ''
          wrapQtApp $out/bin/plover
        '';
    });
in {
  home.packages = [
    plover-env
  ];
}
