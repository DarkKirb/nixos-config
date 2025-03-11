final: prev: {
  fcitx5-table-extra = prev.fcitx5-table-extra.overrideAttrs (super: {
    patches = super.patches or [ ] ++ [
      ./fcitx-table-extra/sitelen-pona.patch
    ];
  });
}
