{ gomod2nix, lib }:
{ sourcePath, targetDir }:
''
  ${lib.getExe' gomod2nix "gomod2nix"} generate --dir ${sourcePath} --outdir ${targetDir}
''
