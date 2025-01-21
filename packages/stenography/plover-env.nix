{
  plover,
  plover_plugins_manager,
  plover_lapwing_aio,
  plover_uinput,
  qt5,
}:
(plover.pythonModule.withPackages (_: [
  plover_plugins_manager
  plover_lapwing_aio
  plover_uinput
])).overrideDerivation
  (super: {
    nativeBuildInputs = super.nativeBuildInputs or [ ] ++ [ qt5.wrapQtAppsHook ];
    postBuild =
      super.postBuild
      + ''
        wrapQtApp $out/bin/plover
      '';
  })
