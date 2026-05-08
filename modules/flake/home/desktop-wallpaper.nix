# Wallpaper rotation via swww — workstation-user role.
#
# Pick a random image from ~/Pictures/wallpapers and set it via swww every
# 15 min. BYO directory — intentional so the repo stays free of large binary
# blobs. If the directory is missing or empty the script no-ops cleanly.
{
  flake.modules.homeManager.workstation-user =
    {
      pkgs,
      config,
      ...
    }:
    let
      wallpaperDir = "${config.home.homeDirectory}/Pictures/wallpapers";
      rotateScript = pkgs.writeShellScript "swww-rotate" ''
        set -eu
        dir="${wallpaperDir}"
        [ -d "$dir" ] || exit 0
        pick=$(${pkgs.findutils}/bin/find "$dir" -type f \
          \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) \
          | ${pkgs.coreutils}/bin/shuf -n1)
        [ -n "$pick" ] || exit 0
        ${pkgs.awww}/bin/swww img "$pick" \
          --transition-type random \
          --transition-duration 1
      '';
    in
    {
      home.packages = [ pkgs.awww ];

      systemd.user.services.swww-rotate = {
        Unit = {
          Description = "Rotate desktop wallpaper via swww";
          After = [ "graphical-session.target" ];
          PartOf = [ "graphical-session.target" ];
        };
        Service = {
          Type = "oneshot";
          ExecStart = "${rotateScript}";
        };
      };

      systemd.user.timers.swww-rotate = {
        Unit = {
          Description = "Rotate desktop wallpaper every 15 minutes";
          PartOf = [ "graphical-session.target" ];
        };
        Timer = {
          OnBootSec = "30s";
          OnUnitActiveSec = "15min";
          Unit = "swww-rotate.service";
        };
        Install.WantedBy = [ "timers.target" ];
      };
    };
}
