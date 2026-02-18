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
    inputs.astal.packages."x86_64-linux".default
    inputs.nixCats.packages."x86_64-linux".nixCats
    (pkgs.python311.withPackages (ppkgs: [
      ppkgs.numpy
      ppkgs.scipy
      ppkgs.matplotlib
      ppkgs.jupyterlab
    ]))
    pkgs.scala
    pkgs.sbt
  ];

  programs.hyprpanel = {
    enable = true;

    # Configure and theme almost all options from the GUI.
    # See 'https://hyprpanel.com/configuration/settings.html'.
    # Default: <same as gui>
    settings = {
      # Configure bar layouts for monitors.
      # See 'https://hyprpanel.com/configuration/panel.html'.
      # Default: null
      layout = {
        bar.layouts = {
          "0" = {
            left = [ "dashboard" "workspaces" ];
            middle = [ "media" ];
            right = [ "volume" "systray" "notifications" ];
          };
        };
      };

      bar.launcher.autoDetectIcon = true;
      bar.workspaces.show_icons = true;

      menus.clock = {
        time = {
          military = true;
          hideSeconds = true;
        };
        weather.unit = "metric";
      };

      menus.dashboard.directories.enabled = false;
      menus.dashboard.stats.enable_gpu = true;

      theme.bar = {
        transparent = true;
        floating = true;
        outer_spacing = "0px";
        buttons.y_margins = "0px";
        margin_top = "4px";
        margin_sides = "0px";
        margin_bottom = "4px";
      };

      theme.font = {
        name = "CaskaydiaCove NF";
        size = "16px";
      };
    };

    systemd.enable = true;
  };

  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host github.com
        HostName github.com
        IdentityFile ~/.ssh/id_ed25519_personal

      Host work.github.com
        HostName github.com
        IdentityFile ~/.ssh/id_ed25519_work

      Host school.gitlab.com
        HostName gitlab.epfl.ch
        IdentityFile ~/.ssh/id_ed25519_school
    '';
  };

  programs.git = {
    enable = true;
    userEmail = "bkjn415@gmail.com";
    userName = "bkjn2040";
  };

  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      package = pkgs.nerd-fonts.jetbrains-mono;
    };
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      format = "[](#9A348E)$os$username[](bg:#DA627D fg:#9A348E)$directory[](fg:#DA627D bg:#FCA17D)$git_branch$git_status[](fg:#FCA17D bg:#86BBD8)$c$elixir$elm$golang$gradle$haskell$java$julia$nodejs$nim$rust$scala[](fg:#86BBD8 bg:#06969A)$docker_context[](fg:#06969A bg:#33658A)$time[ ](fg:#33658A)";
      username = {
        show_always = true;
        style_user = "bg:#9A348E";
        style_root = "bg:#9A348E";
        format = "[$user ]($style)";
        disabled = false;
      };
      os = {
        style = "bg:#9A348E";
        disabled = true;
      };
      directory = {
        style = "bg:#DA627D";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";
        substitutions = {
          Documents = "󰈙 ";
          Downloads = " ";
          Music = " ";
          Pictures = " ";
        };
      };
    };
  };

  programs.tmux = {
    enable = true;
  };

  programs.firefox = {
    enable = true;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    settings = {
      exec-once = "hyprpanel";
      "$mod" = "SUPER";
      bind = [
        "$mod, F, exec, firefox"
	"$mod, Q, exit"
	"$mod, RETURN, exec, kitty"
	"$mod, C, killactive"

	"$mod, H, movefocus, l"
	"$mod, J, movefocus, d"
	"$mod, K, movefocus, u"
	"$mod, L, movefocus, r"

	"$mod SHIFT, H, movewindow, l"
	"$mod SHIFT, J, movewindow, d"
	"$mod SHIFT, K, movewindow, u"
	"$mod SHIFT, L, movewindow, r"

        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"

        "$mod CTRL, H, workspace, r-1"
        "$mod CTRL, L, workspace, r+1"
      ];
      general = {
        gaps_in  = 4;
	gaps_out = "0,16,16,16";
      };
      input = {
        natural_scroll = true;
      };
      decoration = {
        rounding = 8;
      };
      misc = {
        disable_splash_rendering = true;
	disable_hyprland_logo = true;
        background_color = "0xB3EBF2";
      };
    };
  };

  programs.obsidian = {
    enable = true;
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
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
    EDITOR = "neovim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
