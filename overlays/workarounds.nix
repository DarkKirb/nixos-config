final: prev: {
  mesa_unstable = prev.mesa.overrideAttrs (super: {
    patches = super.patches or [ ] ++ [
      (final.fetchpatch {
        url = "https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/33853.patch";
        hash = "sha256-6A9AkCa+DeUO683hlsNTvSWGFJJ+zfqYA2BThaqCEoU=";
      })
    ];
  });
  fcitx5-table-extra = prev.fcitx5-table-extra.overrideAttrs (super: {
    patches = super.patches or [ ] ++ [
      ./fcitx-table-extra/sitelen-pona.patch
    ];
  });
  ubootRaspberryPi4_64bit = prev.ubootRaspberryPi4_64bit.override (super: {
    extraConfig =
      super.extraConfig or ""
      + ''
        CONFIG_EFI_HAVE_RUNTIME_RESET=n
      '';
  });
}
