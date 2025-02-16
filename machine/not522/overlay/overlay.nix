self: super: {
  luaInterpreters = super.luaInterpreters // (self.callPackage ./lua { });

  inherit (self.luaInterpreters) luajit_2_1;
  luajitPackages = self.recurseIntoAttrs self.luajit.pkgs;
  luajit = self.luajit_2_1;

  dbus = super.dbus.override {
    x11Support = false;
  };

  gobject-introspection-unwrapped = super.gobject-introspection-unwrapped.override {
    x11Support = false;
  };
}
