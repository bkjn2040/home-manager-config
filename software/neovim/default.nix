{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withPython3 = false;
    withRuby = false;

    plugins = with pkgs.vimPlugins; [
      oil-nvim
      plenary-nvim
      telescope-nvim
    ];

    # Telescope calls these executables for fast file and text searches.
    extraPackages = with pkgs; [
      fd
      ripgrep
    ];
  };

  home.shellAliases.v = "nvim";

  # Keep the configuration as normal Lua. Nix is responsible for installing
  # Neovim and, later, plugins, LSP servers, formatters, and other executables.
  xdg.configFile."nvim" = {
    source = ./config;
    recursive = true;
  };
}
