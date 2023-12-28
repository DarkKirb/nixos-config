{fetchurl}: {
  core = fetchurl {
    url = "https://dev.bukkit.org/projects/multiverse-core/files/4744018/download";
    sha256 = "98237aaf35c6ee7bfd95fb7f399ef703b3e72bff8eab488a904aad9d4530cd10";
    name = "Multiverse-Core-4.3.12.jar";
  };
  nether-portals = fetchurl {
    url = "https://dev.bukkit.org/projects/multiverse-netherportals/files/4721150/download";
    sha256 = "97283955a93ada82f5e7093880384823e224671978b8e6769e3c27ba15b1bac3";
    name = "Multiverse-NetherPortals-4.2.3.jar";
  };
  sign-portals = fetchurl {
    url = "https://dev.bukkit.org/projects/multiverse-signportals/files/4721189/download";
    sha256 = "149912e64cc27c44fb78e6ea127556e4ae7388d9e9e41ddb6b13e34203112fab";
    name = "Multiverse-SignPortals-4.2.2.jar";
  };
  inventories = fetchurl {
    url = "https://dev.bukkit.org/projects/multiverse-inventories/files/4721185/download";
    sha256 = "2e1ef793883d8911690ccb5f8b9389306f5b95ab915f067875ff33b7cec4a7e8";
    name = "Multiverse-Inventories-4.2.6.jar";
  };
}
