self: super: {
  dbus = super.dbus.override {
    x11Support = false;
  };

  gobject-introspection-unwrapped = super.gobject-introspection-unwrapped.override {
    x11Support = false;
  };
}
