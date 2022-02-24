{ fetchurl }: {
  core = fetchurl {
    url = "https://dev.bukkit.org/projects/multiverse-core/files/3462546/download";
    sha256 = "38c8b6a6aa168ae6a09cc0c9f77115ea975768410bc107c4ce0b32de1bebc787";
    name = "Multiverse-Core-4.3.2.jar";
  };
  nether-portals = fetchurl {
    url = "https://dev.bukkit.org/projects/multiverse-netherportals/files/3074616/download";
    sha256 = "3a9e2c847c481d017890eaf3ad79bd9abcb1fb6cc53ea4a0328c2f43de611db8";
    name = "Multiverse-NetherPortals-4.2.1.jar";
  };
  sign-portals = fetchurl {
    url = "https://dev.bukkit.org/projects/multiverse-signportals/files/3074605/download";
    sha256 = "f4eb45039884a9cad891cef6f7b0a27f36f8bf62b2cb64dd2eb43837146c2dd9";
    name = "Multiverse-SignPortals-4.2.0.jar";
  };
  inventories = fetchurl {
    url = "https://dev.bukkit.org/projects/multiverse-inventories/files/3222929/download";
    sha256 = "bf28c15b679ccb8a1aef4f0e8e78a3234632f67657a2b7fadf40d97ce7563570";
    name = "Multiverse-Inventories-4.2.2.jar";
  };
}
