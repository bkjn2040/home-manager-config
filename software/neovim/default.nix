{ ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withPython3 = false;
    withRuby = false;
  };

  # Keep the configuration as normal Lua. Nix is responsible for installing
  # Neovim and, later, plugins, LSP servers, formatters, and other executables.
  xdg.configFile."nvim" = {
    source = ./config;
    recursive = true;
  };
}
