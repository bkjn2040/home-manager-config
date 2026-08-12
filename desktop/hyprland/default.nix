{ lib, pkgs, ... }:

let
  lua = lib.generators.mkLuaInline;
  call = args: { _args = args; };
  dispatcher = expression: lua expression;
  bind = keys: expression: call [ keys (dispatcher expression) ];
  flaggedBind = keys: expression: flags: call [ keys (dispatcher expression) flags ];
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;

    # Hyprland 0.55 deprecated hyprlang; 0.56 uses hyprland.lua natively.
    configType = "lua";

    settings = {
      config = {
        general = {
          gaps_in = 4;
          gaps_out = {
            top = 0;
            right = 16;
            bottom = 16;
            left = 16;
          };
        };

        input = {
          natural_scroll = false;
          sensitivity = -0.1;
          accel_profile = "flat";
          kb_layout = "us,kr";
          kb_options = "grp:alt_shift_toggle";
        };

        decoration.rounding = 8;

        misc = {
          disable_splash_rendering = true;
          disable_hyprland_logo = true;
          background_color = "#b3ebf2";
        };
      };

      monitor = [
        {
          output = "DP-2";
          mode = "1920x1080@144";
          position = "0x0";
          scale = 1;
        }
        {
          output = "HDMI-A-1";
          mode = "1920x1080@60";
          position = "-1920x0";
          scale = 1;
        }
      ];

      bind = [
        (bind "SUPER + SPACE" ''hl.dsp.exec_cmd("nc -U /run/user/1000/walker/walker.sock")'')
        (bind "SUPER + Q" ''hl.dsp.exec_cmd("hyprshutdown")'')
        (bind "SUPER + RETURN" ''hl.dsp.exec_cmd("kitty")'')
        (bind "SUPER + C" "hl.dsp.window.close()")

        (bind "SUPER + H" ''hl.dsp.focus({ direction = "l" })'')
        (bind "SUPER + J" ''hl.dsp.focus({ direction = "d" })'')
        (bind "SUPER + K" ''hl.dsp.focus({ direction = "u" })'')
        (bind "SUPER + L" ''hl.dsp.focus({ direction = "r" })'')

        (bind "SUPER + SHIFT + H" ''hl.dsp.window.move({ direction = "l" })'')
        (bind "SUPER + SHIFT + J" ''hl.dsp.window.move({ direction = "d" })'')
        (bind "SUPER + SHIFT + K" ''hl.dsp.window.move({ direction = "u" })'')
        (bind "SUPER + SHIFT + L" ''hl.dsp.window.move({ direction = "r" })'')

        (bind "SUPER + 1" ''hl.dsp.focus({ workspace = "r~1" })'')
        (bind "SUPER + 2" ''hl.dsp.focus({ workspace = "r~2" })'')
        (bind "SUPER + 3" ''hl.dsp.focus({ workspace = "r~3" })'')
        (bind "SUPER + 4" ''hl.dsp.focus({ workspace = "r~4" })'')
        (bind "SUPER + 5" ''hl.dsp.focus({ workspace = "r~5" })'')

        (bind "SUPER + SHIFT + 1" ''hl.dsp.window.move({ workspace = "r~1", follow = true })'')
        (bind "SUPER + SHIFT + 2" ''hl.dsp.window.move({ workspace = "r~2", follow = true })'')
        (bind "SUPER + SHIFT + 3" ''hl.dsp.window.move({ workspace = "r~3", follow = true })'')
        (bind "SUPER + SHIFT + 4" ''hl.dsp.window.move({ workspace = "r~4", follow = true })'')
        (bind "SUPER + SHIFT + 5" ''hl.dsp.window.move({ workspace = "r~5", follow = true })'')

        (bind "SUPER + W" ''hl.dsp.submap("workspace")'')
        (bind "SUPER + SHIFT + W" ''hl.dsp.submap("editworkspace")'')
        (flaggedBind "W" ''hl.dsp.submap("reset")'' {
          release = true;
          transparent = true;
          ignore_mods = true;
          non_consuming = true;
          submap_universal = true;
        })
        (bind "SUPER + S" ''hl.dsp.submap("resize")'')
      ];
    };

    submaps = {
      workspace.settings.bind = [
        (flaggedBind "H" ''hl.dsp.focus({ workspace = "r-1" })'' { ignore_mods = true; })
        (flaggedBind "L" ''hl.dsp.focus({ workspace = "r+1" })'' { ignore_mods = true; })
      ];

      editworkspace.settings.bind = [
        (flaggedBind "H" ''hl.dsp.window.move({ workspace = "r-1", follow = true })'' { ignore_mods = true; })
        (flaggedBind "L" ''hl.dsp.window.move({ workspace = "r+1", follow = true })'' { ignore_mods = true; })
      ];

      resize.settings.bind = [
        (flaggedBind "S" ''hl.dsp.submap("reset")'' {
          release = true;
          transparent = true;
          ignore_mods = true;
        })
        (flaggedBind "H" "hl.dsp.window.resize({ x = -20, y = 0, relative = true })" {
          repeating = true;
          ignore_mods = true;
        })
        (flaggedBind "L" "hl.dsp.window.resize({ x = 20, y = 0, relative = true })" {
          repeating = true;
          ignore_mods = true;
        })
        (flaggedBind "K" "hl.dsp.window.resize({ x = 0, y = -20, relative = true })" {
          repeating = true;
          ignore_mods = true;
        })
        (flaggedBind "J" "hl.dsp.window.resize({ x = 0, y = 20, relative = true })" {
          repeating = true;
          ignore_mods = true;
        })
      ];
    };
  };

  home.pointerCursor =
    let
      getFrom = url: hash: name: {
        enable = true;
        gtk.enable = true;
        x11.enable = true;
        inherit name;
        size = 16;
        package = pkgs.runCommand "moveUp" { } ''
          mkdir -p $out/share/icons
          ln -s ${
            pkgs.fetchzip {
              inherit url hash;
            }
          } $out/share/icons/${name}
        '';
      };
    in
    getFrom
      "https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.7/Bibata-Modern-Ice.tar.xz"
      "sha256-SG/NQd3K9DHNr9o4m49LJH+UC/a1eROUjrAQDSn3TAU="
      "Bibata-Modern-Ice";
}
