# NixOS workstation role — desktop/Wayland system-side bits.
#
# Pairs with `flake.modules.homeManager.workstation-user` (sway HM config).
# A host opts into a graphical desktop by importing both modules.
{
  flake.modules.nixos.workstation =
    { pkgs, ... }:
    {
      # Sway (Wayland) — system-side enable. The user-side config (keybinds,
      # waybar, swaylock, swayidle, wallpaper rotation) lives in
      # modules/flake/home/desktop-*.nix and reaches this host via the
      # workstation-user role wired from modules/flake/hosts/nixos.nix.
      programs.sway = {
        enable = true;
        xwayland.enable = true;
      };

      # XDG portals: file pickers, screen sharing, etc. wlr portal for sway,
      # gtk portal as a fallback for non-portal-aware apps.
      xdg.portal = {
        enable = true;
        wlr.enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
        config.common.default = "*";
      };

      # PAM file required for swaylock to actually authenticate. The HM-side
      # programs.swaylock only writes ~/.config/swaylock/config; the PAM
      # service itself has to be declared at the system level.
      security.pam.services.swaylock = { };

      # GDM (Wayland greeter) — keeps the existing login flow; sway shows up as
      # a session option automatically once programs.sway.enable is set above.
      services.displayManager.gdm.enable = true;

      # Audio (pipewire). Disable pulseaudio so pipewire's pulse compat is the
      # only PA server.
      services.pulseaudio.enable = false;
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };

      # Printing.
      services.printing.enable = true;
    };
}
