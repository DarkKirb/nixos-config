{
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./globals.nix
    ./plugins/lazy-nvim.nix
  ];
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [ lazy-nvim ];
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    defaultEditor = true;
    extraLuaConfig = ''
      -- This is my personal Nvim configuration supporting Mac, Linux and Windows, with various plugins configured.
      -- This configuration evolves as I learn more about Nvim and become more proficient in using Nvim.
      -- Since it is very long (more than 1000 lines!), you should read it carefully and take only the settings that suit you.
      -- I would not recommend cloning this repo and replace your own config. Good configurations are personal,
      -- built over time with a lot of polish.
      --
      -- Author: Jiedong Hao
      -- Email: jdhao@hotmail.com
      -- Blog: https://jdhao.github.io/
      -- GitHub: https://github.com/jdhao
      -- StackOverflow: https://stackoverflow.com/users/6064933/jdhao
      local core_conf_files = {
        "globals.lua", -- some global settings
        "options.vim", -- setting options in nvim
        "autocommands.vim", -- various autocommands
        "mappings.lua", -- all the user-defined mappings
        "plugins.lua",
        "plugins.vim",
        "colorschemes.lua", -- colorscheme settings
      }

      local viml_conf_dir = vim.fn.stdpath("config") .. "/viml_conf"
      -- source all the core config files
      for _, file_name in ipairs(core_conf_files) do
        if vim.endswith(file_name, 'vim') then
          local path = string.format("%s/%s", viml_conf_dir, file_name)
          local source_cmd = "source " .. path
          vim.cmd(source_cmd)
        else
          local module_name, _ = string.gsub(file_name, "%.lua", "")
          package.loaded[module_name] = nil
          require(module_name)
        end
      end
    '';
    withPython3 = true;
  };
  systemd.user.tmpfiles.rules = [
    "d /persistent${config.xdg.cacheHome}/nvim/undo-files 0700 - -  mM:1w -"
    "d /persistent${config.xdg.cacheHome}/nvim/swap-files 0700 - -  mM:1w -"
    "d /persistent${config.xdg.cacheHome}/nvim/backup-files 0700 - -  mM:1w -"
  ];
  xdg.configFile.nvim = {
    recursive = true;
    source = ./config;
  };
}
