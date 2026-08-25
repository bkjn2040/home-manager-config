{ lib, pkgs, ... }:

let
  lua = lib.generators.mkLuaInline;
  call = args: { _args = args; };
  dispatcher = expression: lua expression;
  bind = keys: expression: call [ keys (dispatcher expression) ];
  flaggedBind = keys: expression: flags: call [ keys (dispatcher expression) flags ];
  smartFocus = direction: key: ''
    function()
      local window = hl.get_active_window()
      local class = window and string.lower(window.class or "") or ""
      local title = window and (window.title or "") or ""

      if class == "kitty" and string.find(title, "[nvim]", 1, true) then
        hl.dispatch(hl.dsp.send_key_state({
          mods = "CTRL",
          key = "${key}",
          state = "down",
          window = window,
        }))
        hl.dispatch(hl.dsp.send_key_state({
          mods = "CTRL",
          key = "${key}",
          state = "up",
          window = window,
        }))
      else
        hl.dispatch(hl.dsp.focus({ direction = "${direction}" }))
      end
    end
  '';
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    extraLuaFiles.workspaces.content = ''
      local fullscreen_origins = {}

      local function window_key(window)
        return tostring(window.address)
      end

      local function workspace_selector(workspace)
        if workspace == nil then
          return nil
        end

        local id = tostring(workspace.id)
        local name = tostring(workspace.name)
        return name == id and id or "name:" .. name
      end

      local function dedicated_workspace(window)
        return "name:fullscreen-" .. window_key(window)
      end

      hl.workspace_rule({
        workspace = "n[s:fullscreen-]",
        gaps_in = 0,
        gaps_out = 0,
      })

      hl.on("window.fullscreen", function(window)
        if window == nil then
          return
        end

        local key = window_key(window)
        local origin = fullscreen_origins[key]
        local is_fullscreen = window.fullscreen == 2 or window.fullscreen == 3

        if is_fullscreen and origin == nil then
          origin = workspace_selector(window.workspace)
          if origin == nil then
            return
          end

          fullscreen_origins[key] = origin
          hl.dispatch(hl.dsp.window.move({
            workspace = dedicated_workspace(window),
            follow = true,
            window = window,
          }))
        elseif not is_fullscreen and origin ~= nil then
          fullscreen_origins[key] = nil
          hl.dispatch(hl.dsp.window.move({
            workspace = origin,
            follow = true,
            window = window,
          }))
        end
      end)

      hl.on("window.close", function(window)
        if window ~= nil then
          fullscreen_origins[window_key(window)] = nil
        end
      end)

      hl.bind("SUPER + F", hl.dsp.window.fullscreen({
        mode = "fullscreen",
        action = "toggle",
      }), {
        description = "Toggle fullscreen in a dedicated workspace",
      })
    '';

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

        (bind "SUPER + H" (smartFocus "l" "h"))
        (bind "SUPER + J" (smartFocus "d" "j"))
        (bind "SUPER + K" (smartFocus "u" "k"))
        (bind "SUPER + L" (smartFocus "r" "l"))

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
