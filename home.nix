{ config, pkgs, inputs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "jun2040";
  home.homeDirectory = "/home/jun2040";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    inputs.nixCats.packages."x86_64-linux".nixCats

    # (pkgs.python311.withPackages (ppkgs: [
    #   ppkgs.tqdm
    #   ppkgs.bqplot
    #   ppkgs.numpy
    #   ppkgs.scipy
    #   ppkgs.matplotlib
    #   ppkgs.jupyterlab
    # ]))
    pkgs.scala
    pkgs.sbt
    pkgs.gcc
    pkgs.cmake
    pkgs.guitarix

    pkgs.pwvucontrol
    pkgs.mpv
    pkgs.smplayer

    pkgs.grim
    pkgs.slurp
    pkgs.wl-clipboard

    pkgs.feh

    pkgs.zip

    pkgs.nettools

    pkgs.deskreen

    pkgs.davinci-resolve

    pkgs.shotcut

    pkgs.blender

    pkgs.codex
  ];

  imports = [
    ./desktop/hyprland
    # ./desktop/hyprpanel
    ./desktop/walker
    ./desktop/starship
    ./desktop/tmux

    ./software/discord
    ./software/spotify
    ./software/kitty
    ./software/firefox
    ./software/git
    ./software/ssh
    ./software/ticktick
    ./software/unzip
    ./software/superproductivity
  ];

  services.wayle = {
    enable = true;

    # Whether to automatically install soft dependencies used by wayle that
    # will be required based on your config.
    autoInstallDependencies = true;

    # tip: you can automatically translate your TOML config to Nix by running
    # nix-instantiate --eval --expr 'builtins.fromTOML (builtins.readFile ./config.toml)' | nixfmt
    settings = {
      bar = {
        layout = [
          # add more attribute sets with different monitors if wayle should
          # have different layouts on each
          {
            monitor = "*"; # replace "DP-1" with "*" for all monitors
            show = true;
            center = [
              "clock"
              "weather"
            ];
            left = [ "dashboard" ];
            right = [ "volume" ];
          } # this is a 'list' of 'attribute sets', no semi-colons after the closing braces needed
        ];
      };
      modules = {
        clock = {
          format = "%H:%M:%S";
          dropdown-show-seconds = false;
        };
        weather = {
          location = "Denver";
          units = "imperial";
        };
      };
      osd = {
        monitor = "DP-1";
      };
      styling = {
        palette = {
          bg = "#282a36";
          blue = "#8be9fd";
          # ...
        };
        # wallust will be automatically installed if this is set
        theme-provider = "wallust";
      };
      # the following wallpaper option can be omitted if you're not using
      # wayle's wallpaper engine
      wallpaper = {
        # this will automatically install aww
        engine-enabled = true;

        cycling-directory = "/home/horsey/Pictures/Backgrounds/1/";
        cycling-mode = "shuffle";
      };
    };
  };

  # Home Manager is pretty goo at managing otfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/jun2040/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  programs.bash.sessionVariables = {
    TERM = "xterm-color256";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
