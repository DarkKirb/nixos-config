{ config, ... }:
{
  services.nextjs-ollama-llm-ui = {
    enable = config.system.isGraphical;
    port = 22278;
    ollamaUrl = "http://rainbow-resort.int.chir.rs:11434";
  };
}
