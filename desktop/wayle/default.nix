{ ... }:

{
  services.wayle = {
    enable = true;
    autoInstallDependencies = true;

    settings = {
      general = {
        font-sans = "CaskaydiaCove NF";
        font-mono = "CaskaydiaCove NF";
      };

      bar = {
        layout = [
          {
            monitor = "*";
            show = true;
            left = [
              "dashboard"
              "hyprland-workspaces"
            ];
            center = [
              "media"
              "clock"
            ];
            right = [
              "volume"
              "systray"
              "notifications"
            ];
          }
        ];

        # Match HyprPanel's transparent, floating bar with 4 px edge spacing.
        background-opacity = 0;
        inset-edge = 0.25;
        inset-ends = 0.0;
        rounding = "sm";
        shadow = "none";
      };

      modules = {
        dashboard.icon-override = "";

        hyprland-workspaces.app-icons-show = true;

        clock = {
          format = "%H:%M";
          dropdown-show-seconds = false;
        };

        weather = {
          location = "Amsterdam";
          units = "metric";
          time-format = "24h";
        };
      };

      # HyprPanel did not manage the wallpaper, so leave Wayle's engine off.
      wallpaper.engine-enabled = false;
    };
  };

  xdg.configFile."wayle/styles/index.scss" = {
    force = true;
    text = ''
      :root {
        --bar-btn-label-size: 16px;
      }
    '';
  };
}
