{
  plover,
  plover_plugins_manager,
  plover_machine_hid,
  plover_dotool_output,
  plover_lapwing_aio,
  qt5,
}:
(plover.pythonModule.withPackages (_: [
  plover_plugins_manager
  plover_machine_hid
  plover_dotool_output
  plover_lapwing_aio
])).overrideDerivation
  (super: {
    nativeBuildInputs = super.nativeBuildInputs or [ ] ++ [ qt5.wrapQtAppsHook ];
    postBuild =
      super.postBuild
      + ''
        wrapQtApp $out/bin/plover
      '';
  })
