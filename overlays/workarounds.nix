final: prev: {
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
  cinny-unwrapped = prev.cinny-unwrapped.overrideAttrs (super: {
    patches = super.patches or [ ] ++ [
      ./cinny/cinny-msc4144.patch
    ];
  });
}
