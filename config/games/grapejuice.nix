{ system, nix-gaming, ... } @ args: { config, pkgs, ... }:
let
  wine-tkg = nix-gaming.outputs.packages.${system}.wine-tkg;
  hardware-profiles = {
    nutty-noon = {
      graphics_id = "a94037840edd11a1718c5e61863296c68fe0790392d2c0bc984ceb3d7236a90e";
      gpu_vendor_id = 1;
      gpu_pci_id = 1;
      gpu_can_do_vulkan = true;
      provider_index = 0;
      provider_name = "Advanced Micro Devices, Inc. [AMD/ATI] Navi 14 ...";
      should_prime = false;
      use_mesa_gl_override = false;
      preferred_roblox_renderer_string = "Vulkan";
      is_multi_gpu = false;
      version = 2;
    };
    thinkrac = { };
  };
  grapejuice_config = {
    __version__ = 2;
    __hardware_profiles__ = hardware-profiles.${args.config.networking.hostName};
    show_fast_flag_warning = true;
    no_daemon_mode = true;
    release_channel = "master";
    disable_updates = false;
    ignore_wine_version = false;
    try_profiling_hardware = false;
    wineprefixes = [
      {
        id = "4106ce6d-ab2d-4684-89cf-8ee0695e0150";
        priority = 0;
        name_on_disk = "player";
        display_name = "Player";
        wine_home = "${wine-tkg}";
        dll_overrides = "dxdiagn=;winemenubuilder.exe=";
        prime_offload_sink = -1;
        use_mesa_gl_override = false;
        enable_winedebug = false;
        winedebug_string = "";
        roblox_renderer = "Vulkan";
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
          dxvk = true;
        };
      }
      {
        id = "d5f4d5a5-d707-4821-b5b3-cdad9ff13d5b";
        priority = 0;
        name_on_disk = "studio";
        display_name = "Studio";
        wine_home = "${wine-tkg}";
        dll_overrides = "dxdiagn=;winemenubuilder.exe=";
        prime_offload_sink = -1;
        use_mesa_gl_override = false;
        enable_winedebug = false;
        winedebug_string = "";
        roblox_renderer = "Vulkan";
        env = { };
        hints = [
          "studio"
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
          dxvk = true;
        };
      }
    ];
  };
in
{

  home.packages = [
    pkgs.grapejuice
  ];
  home.file.".config/brinkervii/grapejuice/user_settings.json".text = builtins.toJSON grapejuice_config;
}
