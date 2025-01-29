{ ... }:
{

  services.ollama = {
    enable = true;
    acceleration = "rocm";
    host = "[::]";
  };

  environment.persistence."/persistent".directories = [ "/var/lib/private/ollama" ];
}
