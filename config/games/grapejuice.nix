{ system, ... } @ args: { lib, config, pkgs, ... }:
let
  grapejuice_config = {
    __version__ = 2;
    __hardware_profiles__ = null;
    show_fast_flag_warning = true;
    no_daemon_mode = true;
    release_channel = "master";
    disable_updates = false;
    ignore_wine_version = false;
    try_profiling_hardware = false;
    wineprefixes = [
      {
        id = "ec33b6a3-8b44-4179-baec-54cb5bc888cb";
        priority = 0;
        name_on_disk = "player";
        display_name = "Player";
        wine_home = "${pkgs.wineWowPackages.staging}";
        dll_overrides = "dxdiagn=;winemenubuilder.exe=";
        prime_offload_sink = -1;
        use_mesa_gl_override = false;
        enable_winedebug = false;
        winedebug_string = "";
        roblox_renderer = "OpenGL";
        env = { };
        hints = [
          "player"
          "app"
        ];
        fast_flags = {
          roblox_studio = { };
          roblox_player = { };
          roblox_app = { };
        };
        third_party = {
          fps_unlocker = false;
          dxvk = false;
        };
      }
    ];
  };
  grapejuiceJson = pkgs.writeText "grapejuice.json" (builtins.toJSON grapejuice_config);
in
{
  home.packages = [
    pkgs.grapejuice
  ];
  home.activation.grapejuiceSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD mkdir $VERBOSE_ARG -p $HOME/.config/brinkervii/grapejuice
    $DRY_RUN_CMD rm $VERBOSE_ARG -f $HOME/.config/brinkervii/grapejuice/user_settings.json
    $DRY_RUN_CMD cp $VERBOSE_ARG ${grapejuiceJson} $HOME/.config/brinkervii/grapejuice/user_settings.json
    $DRY_RUN_CMD chmod +w $VERBOSE_ARG $HOME/.config/brinkervii/grapejuice/user_settings.json
  '';
}
