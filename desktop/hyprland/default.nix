{ pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    settings = {
      exec-once = [
        "hyprpanel"
        "hyprctl setcursor Bibata-Modern-Ice 16"
      ];
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
        natural_scroll = false;
        sensitivity = -0.1;
        accel_profile = "flat";
      };
      decoration = {
        rounding = 8;
      };
      misc = {
        disable_splash_rendering = true;
	disable_hyprland_logo = true;
        background_color = "0xB3EBF2";
      };
      monitor = [
        "DP-2,1920x1080@144,0x0,1"
        "HDMI-A-1,1920x1080@60,-1920x0,1"
      ];
    };
  };

  home.pointerCursor =
    let
      getFrom = url: hash: name: {
        gtk.enable = true;
        x11.enable = true;
        name = name;
        size = 16;
        package =
          pkgs.runCommand "moveUp" {} ''
            mkdir -p $out/share/icons
            ln -s ${pkgs.fetchzip {
              url = url;
              hash = hash;
            }} $out/share/icons/${name}
          '';
      };
    in
      getFrom
        "https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.7/Bibata-Modern-Ice.tar.xz"
        "sha256-SG/NQd3K9DHNr9o4m49LJH+UC/a1eROUjrAQDSn3TAU="
        "Bibata-Modern-Ice";
}
