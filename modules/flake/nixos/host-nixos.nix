# NixOS host: nixos (the home machine).
#
# Hardware specifics live alongside in
# modules/nixos/_hardware-configurations/nixos.nix (underscore prefix keeps
# import-tree from picking it up; explicitly imported below).
{
  flake.modules.nixos.host-nixos =
    { pkgs, ... }:
    {
      imports = [ ../../nixos/_hardware-configurations/nixos.nix ];

      networking.hostName = "nixos";

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      networking.wireless.enable = true; # wpa_supplicant
      networking.networkmanager.enable = true;

      time.timeZone = "Europe/Copenhagen";
      i18n.defaultLocale = "en_GB.UTF-8";
      i18n.extraLocaleSettings = {
        LC_ADDRESS = "da_DK.UTF-8";
        LC_IDENTIFICATION = "da_DK.UTF-8";
        LC_MEASUREMENT = "da_DK.UTF-8";
        LC_MONETARY = "da_DK.UTF-8";
        LC_NAME = "da_DK.UTF-8";
        LC_NUMERIC = "da_DK.UTF-8";
        LC_PAPER = "da_DK.UTF-8";
        LC_TELEPHONE = "da_DK.UTF-8";
        LC_TIME = "da_DK.UTF-8";
      };
      services.xserver.xkb = {
        layout = "dk";
        variant = "nodeadkeys";
      };
      console.keyMap = "dk-latin1";

      environment.systemPackages = with pkgs; [
        vim
        fuzzel
        waybar
        thunar
        grim
        slurp
        dunst
        awww # was `swww`; renamed upstream
        git
        jujutsu
        xclip
        wl-clipboard
        bash
        zsh
        gnumake
      ];

      # Identity and repo location on this host.
      my.user.name = "normann";
      my.repoPath = "/home/normann/dotfiles";

      # Runtime toolchains for nvim plugin builds (treesitter parsers via gcc,
      # blink.cmp via cargo). Consumed via the shared
      # `my.editor.neovim.extraRuntimePackages` option (forwarded into HM
      # scope by modules/flake/hosts/nixos.nix).
      my.editor.neovim.extraRuntimePackages = with pkgs; [
        gcc
        gnumake
        cargo
        rustc
        nodejs
        bash-language-server
        clang-tools
        lua-language-server
      ];

      # Bump after first successful rebuild on the target machine.
      system.stateVersion = "25.05";
    };
}
