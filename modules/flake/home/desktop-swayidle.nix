# Swayidle: lock-on-idle and DPMS — workstation-user role.
{
  flake.modules.homeManager.workstation-user =
    { pkgs, ... }:
    {
      services.swayidle = {
        enable = true;
        events = {
          before-sleep = "${pkgs.swaylock}/bin/swaylock -f";
          lock = "${pkgs.swaylock}/bin/swaylock -f";
        };
        timeouts = [
          {
            timeout = 600;
            command = "${pkgs.swaylock}/bin/swaylock -f";
          }
          {
            timeout = 900;
            command = ''${pkgs.sway}/bin/swaymsg "output * dpms off"'';
            resumeCommand = ''${pkgs.sway}/bin/swaymsg "output * dpms on"'';
          }
        ];
      };
    };
}
