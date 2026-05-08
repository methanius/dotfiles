# Host-specific NixOS system configuration for the home machine.
#
# Fill in the rest when commissioning the box:

{pkgs, ...}: {
  networking.hostName = "nixos";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;


  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
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

  # Configure console keymap
  console.keyMap = "dk-latin1";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Sway (Wayland) — system-side enable. The user-side config (keybinds,
  # waybar, swaylock, swayidle, wallpaper rotation) lives in
  # modules/home/desktop/default.nix and reaches this host via
  # modules/nixos/home-manager.nix.
  programs.sway = {
    enable = true;
    xwayland.enable = true;
  };

  # XDG portals: file pickers, screen sharing, etc. wlr portal for sway,
  # gtk portal as a fallback for non-portal-aware apps.
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
    config.common.default = "*";
  };

  # PAM file required for swaylock to actually authenticate. The HM-side
  # programs.swaylock only writes ~/.config/swaylock/config; the PAM
  # service itself has to be declared at the system level.
  security.pam.services.swaylock = {};

  environment.systemPackages = with pkgs; [
    vim
    wofi
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
  #  wget
  ];

  # GDM (Wayland greeter) — keeps the existing login flow; sway shows up as
  # a session option automatically once programs.sway.enable is set above.
  # X server itself is no longer enabled; sway is Wayland-native and GDM
  # runs its own internal compositor for the greeter.
  services.displayManager.gdm.enable = true;
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
