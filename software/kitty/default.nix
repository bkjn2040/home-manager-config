{ config, pkgs, inputs, ... }:

{
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      package = pkgs.nerd-fonts.jetbrains-mono;
    };
    keybindings = {
      "super+h" = "send_key ctrl+h";
      "super+j" = "send_key ctrl+j";
      "super+k" = "send_key ctrl+k";
      "super+l" = "send_key ctrl+l";
    };
  };
}
