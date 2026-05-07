# Host-specific NixOS system configuration for the home machine.
#
# Fill in the rest when commissioning the box:
#   - boot.loader.* (systemd-boot vs grub, EFI specifics)
#   - time.timeZone
#   - i18n.defaultLocale / console.keyMap
#   - networking.networkmanager.enable or static config
#   - services.xserver / wayland / desktop environment choices
#   - services.pipewire (audio)
{pkgs, ...}: {
  networking.hostName = "nixos";

  # Identity and repo location on this host.
  my.user.name = "normann";
  my.repoPath = "/home/normann/dotfiles";

  # Runtime toolchains for nvim plugin builds (treesitter parsers via gcc,
  # blink.cmp via cargo). Forwarded into HM scope by
  # modules/nixos/home-manager.nix and consumed by programs.neovim.
  my.editor.neovim.extraRuntimePackages = with pkgs; [
    gcc
    gnumake
    cargo
    rustc
    nodejs
  ];

  # Bump after first successful rebuild on the target machine.
  system.stateVersion = "25.05";
}
