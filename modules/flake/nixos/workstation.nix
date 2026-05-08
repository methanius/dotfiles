# NixOS workstation role — sway-specific system-side bits.
#
# Pairs with `flake.modules.homeManager.workstation-user` (sway HM config).
# Composes `flake.modules.nixos.workstation-common` for the parts shared
# with the niri stack (audio, portal scaffolding, GDM, printing).
{ config, ... }:
{
  flake.modules.nixos.workstation =
    { pkgs, ... }:
    {
      imports = [ config.flake.modules.nixos.workstation-common ];

      # Sway (Wayland) — system-side enable. The user-side config (keybinds,
      # waybar, swaylock, swayidle, wallpaper rotation) lives in
      # modules/flake/home/desktop-*.nix and reaches this host via the
      # workstation-user role wired from modules/flake/hosts/nixos.nix.
      programs.sway = {
        enable = true;
        xwayland.enable = true;
      };

      # XDG portals: wlr backend for sway. gtk fallback for non-portal-aware
      # apps. Common scaffolding (xdg.portal.enable, default config) comes
      # from workstation-common.
      xdg.portal = {
        wlr.enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      };

      # PAM file required for swaylock to actually authenticate. The HM-side
      # programs.swaylock only writes ~/.config/swaylock/config; the PAM
      # service itself has to be declared at the system level.
      security.pam.services.swaylock = { };
    };
}
