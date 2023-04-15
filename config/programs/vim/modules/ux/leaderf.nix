{pkgs, ...}: {
  output.plugins = with pkgs.vimPlugins; [LeaderF];
  vim.g = {
    Lf_UseCache = 0;
    Lf_UseMemoryCache = 0;
    Lf_WildIgnore = {
      dir = [".git" "__pycache__" ".DS_Store"];
      file = [
        "*.exe"
        "*.dll"
        "*.so"
        "*.o"
        "*.pyc"
        "*.jpg"
        "*.png"
        "*.gif"
        "*.svg"
        "*.ico"
        "*.db"
        "*.tgz"
        "*.tar.gz"
        "*.gz"
        "*.zip"
        "*.bin"
        "*.pptx"
        "*.xlsx"
        "*.docx"
        "*.pdf"
        "*.tmp"
        "*.wmv"
        "*.mkv"
        "*.mp4"
        "*.rmvb"
        "*.ttf"
        "*.ttc"
        "*.otf"
        "*.mp3"
        "*.aac"
      ];
    };
    Lf_DefaultMode = "FullPath";
    Lf_UseVersionControlTool = 0;
    Lf_DefaultExternalTool = "rg";
    Lf_ShowHidden = 1;
    Lf_ShortcutF = "";
    Lf_ShortcutB = "";
    Lf_WorkingDirectoryMode = "a";
  };

  vim.keybindings.keybindings."<leader>" = {
    f = {
      f = {
        command = "<Cmd>Leaderf file --popup<CR>";
        options.silent = true;
        label = "Search files";
      };
      g = {
        command = "<Cmd>Leaderf rg --no-messages --popup<CR>";
        options.silent = true;
        label = "Grep files";
      };
      h = {
        command = "<Cmd>Leaderf help --popup<CR>";
        options.silent = true;
        label = "Search help";
      };
      t = {
        command = "<Cmd>Leaderf bufTag --popup<CR>";
        options.silent = true;
        label = "Search tags in buffer";
      };
      b = {
        command = "<Cmd>Leaderf buffer --popup<CR>";
        options.silent = true;
        label = "Switch buffers";
      };
      r = {
        command = "<Cmd>Leaderf mru --popup --absolute-path<CR>";
        options.silent = true;
        label = "search recent files";
      };
    };
  };
}
