{ config, ... }:

{
  programs.firefox = {
    enable = true;
    configPath = "${config.xdg.configHome}/mozilla/firefox";
    policies = {
      Preferences = {
        "browser.startup.homepage" = {
          Value = "about:blank";
          Status = "default";
          Type = "string";
        };
        "browser.startup.page" = {
          Value = 0;
          Status = "default";
          Type = "number";
        };
        "browser.newtabpage.enabled" = {
          Value = false;
          Status = "default";
          Type = "boolean";
        };
        "browser.urlbar.suggest.history" = {
          Value = false;
          Status = "locked";
          Type = "boolean";
        };
        "browser.urlbar.maxHistoricalSearchSuggestions" = {
          Value = 0;
          Status = "locked";
          Type = "number";
        };
        "browser.formfill.enable" = {
          Value = false;
          Status = "locked";
          Type = "boolean";
        };
        "browser.urlbar.quicksuggest.enabled" = {
          Value = false;
          Status = "locked";
          Type = "boolean";
        };
        "browser.urlbar.suggest.quicksuggest.nonsponsored" = {
          Value = false;
          Status = "locked";
          Type = "boolean";
        };
        "browser.urlbar.suggest.quicksuggest.sponsored" = {
          Value = false;
          Status = "locked";
          Type = "boolean";
        };
        "browser.urlbar.quicksuggest.dataCollection.enabled" = {
          Value = false;
          Status = "locked";
          Type = "boolean";
        };
      };
      OverrideFirstRunPage = "";
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
