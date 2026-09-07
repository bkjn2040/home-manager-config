{ config, ... }:

{
  programs.firefox = {
    enable = true;
    configPath = "${config.xdg.configHome}/mozilla/firefox";
    policies = {
      ExtensionSettings = {
        "adguardadblocker@adguard.com" = {
          install_url = "moz-extension://ca89699d-a314-4dac-ac05-8e7c806c603a";
          installation_mode = "force_installed";
          blocked_uninstall = true;
        };
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = "moz-extension://f136d324-2c4e-4b99-91c4-ba1c8dfdcf21";
          installation_mode = "force_installed";
          blocked_uninstall = true;
        };
        "{43e277d7-88f4-4d0f-b14d-3aa428e2da39}" = {
          install_url = "moz-extension://662e9b86-2143-45cd-92bf-7487db2543ab";
          installation_mode = "force_installed";
          blocked_uninstall = true;
        };
      };
      DisableAddons = true;
    };
  };
}
