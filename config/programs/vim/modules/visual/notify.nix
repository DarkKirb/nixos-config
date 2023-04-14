{pkgs, ...}: {
  output.plugins = with pkgs.vimPlugins; [nvim-notify];

  output.extraConfig = ''
    highlight NotifyERRORBorder guifg=#f38ba8
    highlight NotifyWARNBorder guifg=#f9e2af
    highlight NotifyINFOBorder guifg=#89b4fa
    highlight NotifyDEBUGBorder guifg=#a6e3a1
    highlight NotifyTRACEBorder guifg=#ffffff
    highlight NotifyERRORIcon guifg=#f38ba8
    highlight NotifyWARNIcon guifg=#f9e2af
    highlight NotifyINFOIcon guifg=#89b4fa
    highlight NotifyDEBUGIcon guifg=#a6e3a1
    highlight NotifyTRACEIcon guifg=#ffffff
    highlight NotifyERRORTitle  guifg=#f38ba8
    highlight NotifyWARNTitle guifg=#f9e2af
    highlight NotifyINFOTitle guifg=#89b4fa
    highlight NotifyDEBUGTitle  guifg=#a6e3a1
    highlight NotifyTRACETitle  guifg=#ffffff
    highlight link NotifyERRORBody Normal
    highlight link NotifyWARNBody Normal
    highlight link NotifyINFOBody Normal
    highlight link NotifyDEBUGBody Normal
    highlight link NotifyTRACEBody Normal
  '';

  extraLua = ''vim.notify = require("notify")'';
  plugin.setup.notify = {
    stages = "fade_in_slide_out";
    timeout = 1500;
    background_colour = "#1e1e2e";
  };
}
