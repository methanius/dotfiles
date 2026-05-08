# NixOS workstation-common role — bits shared between sway and niri stacks.
#
# Anything that any graphical NixOS host needs regardless of which compositor
# it runs (audio, printing, rtkit, the parts of xdg.portal that aren't
# compositor-specific). Compositor-specific roles (`workstation` for sway,
# `workstation-niri` for niri) compose this in addition to their own bits.
{
  flake.modules.nixos.workstation-common =
    { ... }:
    {
      # XDG portal scaffolding. The compositor-specific role adds the actual
      # backend (wlr for sway, gnome for niri).
      xdg.portal = {
        enable = true;
        config.common.default = "*";
      };

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

      # GDM (Wayland greeter). Sessions appear automatically as compositors
      # are enabled by their respective workstation-* roles.
      services.displayManager.gdm.enable = true;
    };
}
