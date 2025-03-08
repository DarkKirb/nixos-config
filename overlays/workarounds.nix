final: prev: {
  fcitx5-table-extra = prev.fcitx5-table-extra.overrideAttrs (super: {
    patches = super.patches or [ ] ++ [
      ./fcitx-table-extra/sitelen-pona.patch
    ];
  });
  kodi = prev.kodi.override {
    curl = final.curl.overrideAttrs (super: {
      patches = super.patches or [ ] ++ [
        ./curl/curl-fix-scache-bug.patch
      ];
    });
  };
}
