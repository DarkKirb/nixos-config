{ ... }: {
  homepage-old = builtins.fetchTarball {
    url = "https://minio.int.chir.rs/darkkirb.de/homepage.tar.zst";
    sha256 = "1wf90kpb0ra0fy0msh1drmr4jjxw7c1q3ksqc9zfy04sjh6y5msg";
  };
}
