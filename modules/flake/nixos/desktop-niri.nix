# Niri scrollable-tiling Wayland compositor — NixOS-side workstation-niri role.
#
# Adopts upstream `inputs.niri-flake.nixosModules.niri` (sodiboo's flake)
# instead of the nixpkgs `programs/wayland/niri.nix` module that would
# otherwise activate via `programs.niri.enable`. The upstream module:
#
#   - `disabledModules`s the nixpkgs one (so they don't fight),
#   - sets sensible defaults for the surrounding session scaffolding
#     (xdg.portal, polkit, gnome-keyring, hardware.graphics, dconf, fonts,
#     pam.swaylock),
#   - registers `services.displayManager.sessionPackages = [ cfg.package ]`,
#   - declares `niri.cachix.org` as a substituter (toggleable via
#     `niri-flake.cache.enable`, default `true`),
#   - wires a `niri-flake-polkit` user service (KDE polkit agent) `wantedBy`
#     `niri.service` so authentication dialogs work inside the session.
#
# Why we adopted this in C23: the previous approach in this file —
# `pkgs.symlinkJoin` of `niri-stable` + companion CLIs, then
# `wrapProgram $out/bin/niri --prefix PATH` — was bypassed at runtime by
# niri's user systemd unit. The unit file (`niri.service`, surfaced by
# symlinkJoin from the unwrapped niri output) hardcodes
# `ExecStart=/nix/store/.../niri-25.08/bin/niri --session`, so the
# wrapped binary was never executed. niri-flake's `niri-stable` package
# already does an in-tree `substituteInPlace` of that ExecStart= to point
# at its own bin/niri, and when used as `programs.niri.package` directly
# (no symlinkJoin in the way), the unit and binary stay consistent.
#
# Companion runtime tools (grim/slurp/wl-clipboard/brightnessctl/playerctl/
# pamixer/libnotify) are now provided via Home Manager `home.packages`
# (see modules/flake/home/desktop-niri.nix). niri inherits them after
# `systemctl --user import-environment` runs in `niri-session`.
#
# `xwayland-satellite` similarly comes via the upstream package's
# spawn-on-demand path; if explicit installation is desired later, add
# `inputs.niri-flake.packages.<sys>.xwayland-satellite-stable` to
# environment.systemPackages.
{ config, inputs, ... }:
let
  flakeConfig = config;
in
{
  flake.modules.nixos.workstation-niri =
    { pkgs, config, ... }:
    {
      imports = [
        flakeConfig.flake.modules.nixos.workstation-common
        # Upstream NixOS module from niri-flake. Replaces the nixpkgs
        # programs.niri module via its own `disabledModules`.
        inputs.niri-flake.nixosModules.niri
      ];

      programs.niri = {
        enable = true;
        # Use niri-stable from the flake's prebuilt cache rather than
        # nixpkgs's `pkgs.niri` (which is not in cache.nixos.org for fresh
        # releases and would force a ~10-minute Rust compile per host).
        # The niri-flake module declares niri.cachix.org so this binary
        # is substituted, not built.
        package = inputs.niri-flake.packages.${pkgs.stdenv.hostPlatform.system}.niri-stable;
      };

      # Belt-and-suspenders: udev grants seat0 input devices to the
      # session leader, but a few kernels/configurations also gate on
      # the `input` group. Adding it costs nothing and removes one
      # possible cause if input-handoff problems recur.
      users.users.${config.my.user.name}.extraGroups = [ "input" ];

      # niri's recommended portal: gnome backend (handles screencast
      # etc.). Common scaffolding (xdg.portal.enable, default config)
      # comes from workstation-common. niri-flake's module also adds
      # xdg-desktop-portal-gnome conditionally, so this is mostly belt-
      # and-suspenders for an explicit declaration in our role.
      xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
    };
}
