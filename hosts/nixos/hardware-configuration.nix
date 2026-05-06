# Placeholder. Replace the contents of this file with the output of
#   sudo nixos-generate-config --show-hardware-config
# run on the actual home machine. The fileSystems entry below exists only so
# the flake evaluates without the real hardware config; nixos-rebuild will
# refuse to activate this until a real boot/root setup is in place.
{...}: {
  # Minimum viable scaffold so `nix flake check` can evaluate the module set.
  # Replace ALL of this with the generated hardware config.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems."/" = {
    device = "/dev/disk/by-label/PLACEHOLDER";
    fsType = "ext4";
  };

  nixpkgs.hostPlatform = "x86_64-linux";
}
