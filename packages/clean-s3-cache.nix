{ writeTextFile }: writeTextFile {
  name = "clean-s3-cache.py";
  executable = true;
  destination = "/bin/clean-s3-cache.py";
  text = builtins.readFile ./clean-s3-cache.py;
}
