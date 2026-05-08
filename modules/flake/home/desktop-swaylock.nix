# Swaylock screen locker — workstation-user role.
{
  flake.modules.homeManager.workstation-user =
    { ... }:
    {
      programs.swaylock = {
        enable = true;
        settings = {
          color = "000000";
          ignore-empty-password = true;
          show-failed-attempts = true;
        };
      };
    };
}
