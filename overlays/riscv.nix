self: prev: {
  pandoc = prev.writeScriptBin "pandoc" "true";
  meson = prev.meson.overrideAttrs (_: {
    doInstallCheck = false;
  });
}
