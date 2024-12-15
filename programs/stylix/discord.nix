{ pkgs, config, ... }:
let imgSrc = pkgs.stdenvNoCC {
  name = "bg.png.b64";
  src = config.stylix.image;
  dontUnpack = true;
  dontBuild = true;
  installPhase = ''base64 -w 0 $src > $out'';
};
  img = builtins.readFile imgSrc;
{
  xdg.configFile."BetterDiscord/data/stable/custom.css".text =
    with config.lib.stylix.colors.withHashtag; ''
      :root {
          --base00: ${base00}; /* Black */
          --base01: ${base01}; /* Bright Black */
          --base02: ${base02}; /* Grey */
          --base03: ${base03}; /* Brighter Grey */
          --base04: ${base04}; /* Bright Grey */
          --base05: ${base05}; /* White */
          --base06: ${base06}; /* Brighter White */
          --base07: ${base07}; /* Bright White */
          --base08: ${base08}; /* Red */
          --base09: ${base09}; /* Orange */
          --base0A: ${base0A}; /* Yellow */
          --base0B: ${base0B}; /* Green */
          --base0C: ${base0C}; /* Cyan */
          --base0D: ${base0D}; /* Blue */
          --base0E: ${base0E}; /* Purple */
          --base0F: ${base0F}; /* Magenta */

          --primary-630: var(--base00); /* Autocomplete background */
          --primary-660: var(--base00); /* Search input background */
      }

      .app {
        background-image: url("data:image/png;base64,${img}") !important;
        background-size: cover;
      }

      .theme-light, .theme-dark {
          --search-popout-option-fade: none; /* Disable fade for search popout */
          --bg-overlay-2: var(--base00); /* These 2 are needed for proper threads coloring */
          --home-background: var(--base00);
          --background-primary: var(--base00);
          --background-secondary: var(--base01);
          --background-secondary-alt: var(--base01);
          --channeltextarea-background: var(--base01);
          --background-tertiary: var(--base00);
          --background-accent: var(--base0E);
          --background-floating: var(--base01);
          --background-modifier-selected: var(--base00);
          --text-normal: var(--base05);
          --text-secondary: var(--base00);
          --text-muted: var(--base03);
          --text-link: var(--base0C);
          --interactive-normal: var(--base05);
          --interactive-hover: var(--base0C);
          --interactive-active: var(--base0A);
          --interactive-muted: var(--base03);
          --header-primary: var(--base06);
          --header-secondary: var(--base03);
          --scrollbar-thin-track: transparent;
          --scrollbar-auto-track: transparent;
      }

    '';
}
