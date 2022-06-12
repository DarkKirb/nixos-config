{fetchurl}: {
  core = fetchurl {
    url = "https://dev.bukkit.org/projects/multiverse-core/files/3462546/download";
    sha256 = "38c8b6a6aa168ae6a09cc0c9f77115ea975768410bc107c4ce0b32de1bebc787";
    name = "Multiverse-Core-4.3.2.jar";
  };
  nether-portals = fetchurl {
    url = "https://dev.bukkit.org/projects/multiverse-netherportals/files/3687506/download";
    sha256 = "1zcjb5vih519d891mbcd6ngdy4l4c7p83j1bvqazn7x0wq013z6n";
    name = "Multiverse-NetherPortals-4.2.2.jar";
  };
  sign-portals = fetchurl {
    url = "https://dev.bukkit.org/projects/multiverse-signportals/files/3074605/download";
    sha256 = "f4eb45039884a9cad891cef6f7b0a27f36f8bf62b2cb64dd2eb43837146c2dd9";
    name = "Multiverse-SignPortals-4.2.0.jar";
  };
  inventories = fetchurl {
    url = "https://dev.bukkit.org/projects/multiverse-inventories/files/3687469/download";
    sha256 = "1dsnfj94rrv5g0zqvzdbxhla6p1mi53yvkd77c4sy5jmga2alxdi";
    name = "Multiverse-Inventories-4.2.3.jar";
  };
}
