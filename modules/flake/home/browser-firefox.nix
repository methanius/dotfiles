# Firefox — workstation-user role contribution.
#
# Adds Firefox with a declarative default profile and four extensions sourced
# from the NUR `rycee.firefox-addons` set (the canonical Nix-packaged Firefox
# addon repository):
#
#   - Proton Pass     — password manager
#   - Tridactyl       — vim-style keybindings (requires `tridactyl-native`
#                       messenger as a separate package, added to home.packages)
#   - uBlock Origin   — adblocker
#   - SponsorBlock    — skip YouTube sponsor segments
#
# NUR is wired in via a flake input (see flake.nix). It is imported here and
# scoped to this module rather than registered as a global overlay, because
# Firefox is currently the only NUR consumer in the repo.
#
# Also sets Firefox as the default browser for http/https/html via
# xdg.mimeApps so sway/portal hand-offs route here.
{ inputs, ... }:
{
  flake.modules.homeManager.workstation-user =
    { pkgs, ... }:
    let
      addons = (import inputs.nur { inherit pkgs; }).repos.rycee.firefox-addons;
    in
    {
      programs.firefox = {
        enable = true;
        profiles.default = {
          id = 0;
          isDefault = true;
          extensions.packages = with addons; [
            proton-pass
            tridactyl
            ublock-origin
            sponsorblock
          ];
          settings = {
            "browser.aboutConfig.showWarning" = false;

            # Wayland: use xdg-desktop-portal native file picker dialogs.
            "widget.use-xdg-desktop-portal.file-picker" = 1;

            # Telemetry off.
            "datareporting.healthreport.uploadEnabled" = false;
            "datareporting.policy.dataSubmissionEnabled" = false;
            "toolkit.telemetry.enabled" = false;
            "toolkit.telemetry.unified" = false;
            "toolkit.telemetry.archive.enabled" = false;
            "toolkit.telemetry.newProfilePing.enabled" = false;
            "toolkit.telemetry.shutdownPingSender.enabled" = false;
            "toolkit.telemetry.updatePing.enabled" = false;
            "toolkit.telemetry.bhrPing.enabled" = false;
            "toolkit.telemetry.firstShutdownPing.enabled" = false;
            "app.shield.optoutstudies.enabled" = false;
            "browser.ping-centre.telemetry" = false;
          };
        };
      };

      # Tridactyl native messenger — required for `:source`, `:guiset`, and
      # other Tridactyl features that shell out beyond the WebExtension sandbox.
      home.packages = [ pkgs.tridactyl-native ];

      # Default browser for http/https/html link hand-offs.
      xdg.mimeApps = {
        enable = true;
        defaultApplications = {
          "text/html" = "firefox.desktop";
          "x-scheme-handler/http" = "firefox.desktop";
          "x-scheme-handler/https" = "firefox.desktop";
          "x-scheme-handler/about" = "firefox.desktop";
          "x-scheme-handler/unknown" = "firefox.desktop";
        };
      };
    };
}
