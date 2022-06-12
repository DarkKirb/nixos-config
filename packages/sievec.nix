{
  writeText,
  stdenv,
  dovecot_pigeonhole,
  ...
} @ pkgs: {
  name,
  src,
  exts,
}: let
  dummyConfig = writeText "dovecot.cfg" ''
    plugin {
      sieve_plugins = sieve_imapsieve sieve_extprograms
      sieve_global_extensions = +vnd.dovecot.pipe
    }
  '';
in
  stdenv.mkDerivation {
    inherit name;
    inherit src;

    phases = ["copyPhase" "compilePhase"];

    copyPhase = ''
      mkdir $out
      cp $src $out/${name}.sieve
      sed -i 's|/nix/store/||g' $out/${name}.sieve
      chmod 0755 $out/${name}.sieve
      set +x
    '';
    compilePhase = ''
      ${dovecot_pigeonhole}/bin/sievec -c ${dummyConfig} $out/${name}.sieve $out/${name}.svbin -x "${toString exts}"
    '';
  }
