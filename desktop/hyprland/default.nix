{ ... }:

{
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
}
