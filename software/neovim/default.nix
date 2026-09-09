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
      cmp-buffer
      cmp-nvim-lsp
      cmp-path
      cmp_luasnip
      luasnip
      nvim-cmp
      nvim-lspconfig
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
        scala
        vim
        vimdoc
        yaml
      ]))
      oil-nvim
      plenary-nvim
      smart-splits-nvim
      telescope-nvim
      tokyonight-nvim
    ];

    # Telescope calls these executables for fast file and text searches.
    extraPackages = with pkgs; [
      bash-language-server
      clang-tools
      cmake-language-server
      fd
      lua-language-server
      metals
      nixd
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
