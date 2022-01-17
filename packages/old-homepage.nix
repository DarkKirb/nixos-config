{ ... }: {
  old-homepage = builtins.fetchTarball {
    url = "https://minio.int.chir.rs/darkkirb.de/homepage.tar.zst";
    sha256 = "0m449cm13hamxpsqn9p6f6fjf93iz96vp08ghwrbdf8png4n86bp";
  };
}
