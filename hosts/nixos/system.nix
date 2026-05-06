# Host-specific NixOS system configuration for the home machine.
#
# Fill in the rest when commissioning the box:
#   - boot.loader.* (systemd-boot vs grub, EFI specifics)
#   - time.timeZone
#   - i18n.defaultLocale / console.keyMap
#   - networking.networkmanager.enable or static config
#   - services.xserver / wayland / desktop environment choices
#   - services.pipewire (audio)
{...}: {
  networking.hostName = "nixos";

  # Bump after first successful rebuild on the target machine.
  system.stateVersion = "25.05";
}
