{ config, ... }:

{
  programs.firefox = {
    enable = true;
    configPath = "${config.xdg.configHome}/mozilla/firefox";
    policies = {
      ExtensionSettings = {
        "adguardadblocker@adguard.com" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/adguardadblocker@adguard.com/latest.xpi";
          installation_mode = "force_installed";
          blocked_uninstall = true;
        };
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/{446900e4-71c2-419f-a6a7-df9c091e268b}/latest.xpi";
          installation_mode = "force_installed";
          blocked_uninstall = true;
        };
        "{43e277d7-88f4-4d0f-b14d-3aa428e2da39}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/{43e277d7-88f4-4d0f-b14d-3aa428e2da39}/latest.xpi";
          installation_mode = "force_installed";
          blocked_uninstall = true;
        };
      };
      DisableAddons = true;
    };
  };
}
