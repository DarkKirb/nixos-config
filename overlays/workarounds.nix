final: prev: {
  mesa_24_2_8 = final.mesa.overrideAttrs (super: rec {
    version = "24.2.8";
    src = final.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "mesa";
      repo = "mesa";
      rev = "mesa-${version}";
      hash = "sha256-70X0Ba7t8l9Vs/w/3dd4UpTR7woIvd7NRwO/ph2rKu8=";
    };
    patches = [
      (final.fetchpatch {
        url = "https://raw.githubusercontent.com/NixOS/nixpkgs/refs/heads/nixos-24.11/pkgs/development/libraries/mesa/opencl.patch";
        hash = "sha256-csxRQZb5fhGcUFaB18K/8lFyosTQD/P2z7jSSEF7UJs=";
      })
    ];
    mesonFlags = builtins.filter (
      s: !((final.lib.hasInfix "install-mesa-clc" s) || (final.lib.hasInfix "install-precomp-compiler" s))
    ) super.mesonFlags;
    outputs = [
      "out"
      "dev"
      "drivers"
      # OpenCL drivers pull in ~1G of extra LLVM stuff, so don't install them
      # if the user didn't explicitly ask for it
      "opencl"
      # the Dozen drivers depend on libspirv2dxil, but link it statically, and
      # libspirv2dxil itself is pretty chonky, so relocate it to its own output in
      # case anything wants to use it at some point
      "spirv2dxil"
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
