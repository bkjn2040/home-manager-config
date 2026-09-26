{ pkgs, ... }:

let
  luaPackages = pkgs.neovim-unwrapped.lua.pkgs;
in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withPython3 = false;
    withRuby = false;
    extraWrapperArgs = [
      "--set-default"
      "LUA_PATH"
      "${luaPackages.getLuaPath luaPackages.magick};;"
      "--set-default"
      "LUA_CPATH"
      "${luaPackages.getLuaCPath luaPackages.magick};;"
    ];

    plugins = with pkgs.vimPlugins; [
      cmp-buffer
      cmp-nvim-lsp
      cmp-path
      cmp_luasnip
      image-nvim
      luasnip
      nvim-cmp
      nvim-lspconfig
      nvim-web-devicons
      (nvim-treesitter.withPlugins (parsers: with parsers; [
        bash
        c
        cmake
        cpp
        json
        lua
        markdown
        markdown_inline
        nix
        query
        rust
        scala
        vim
        vimdoc
        yaml
      ]))
      oil-nvim
      plenary-nvim
      telescope-fzf-native-nvim
      telescope-live-grep-args-nvim
      telescope-nvim
      telescope-ui-select-nvim
      telescope-undo-nvim
      tokyonight-nvim
    ];

    # Telescope calls these executables for fast file and text searches.
    extraPackages = with pkgs; [
      bash-language-server
      clang-tools
      cmake-language-server
      delta
      fd
      imagemagick
      lua-language-server
      metals
      nixd
      ripgrep
      rust-analyzer
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
