# Niri scrollable-tiling Wayland compositor — NixOS-side workstation-niri role.
#
# Two contributions in one file:
#
#   1. `perSystem.packages.niri-wrapped` (exposed at flake level via
#      flake-parts as `flake.packages.<system>.niri-wrapped`) — a
#      `symlinkJoin` that bundles the upstream `niri` with all the runtime
#      CLIs the compositor shells out to (xwayland-satellite, screenshot
#      and clipboard tools, brightness and media controls, libnotify). The
#      `niri` binary is wrapped with `makeWrapper` so its PATH is hermetic
#      at exec time, regardless of what the user has in `home.packages`.
#      Mirrors the wrapping pattern already used by `programs.neovim` here.
#
#   2. `flake.modules.nixos.workstation-niri` — system-side enable for niri.
#      Composes `workstation-common` for the bits shared with the sway stack
#      (audio, portal scaffolding, GDM, printing). The HM-side config
#      (keybinds, settings) lives in `modules/flake/home/desktop-niri.nix`
#      contributing to the `workstation-niri-user` HM role.
{ config, ... }:
{
  perSystem =
    { pkgs, lib, ... }:
    let
      runtimeDeps = with pkgs; [
        xwayland-satellite
        grim
        slurp
        wl-clipboard
        brightnessctl
        playerctl
        pamixer
        libnotify
      ];
    in
    {
      packages.niri-wrapped = pkgs.symlinkJoin {
        name = "niri-wrapped";
        paths = [ pkgs.niri ] ++ runtimeDeps;
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/niri \
            --prefix PATH : ${lib.makeBinPath runtimeDeps}
        '';
      };
    };

  flake.modules.nixos.workstation-niri =
    { pkgs, ... }:
    {
      imports = [ config.flake.modules.nixos.workstation-common ];

      programs.niri = {
        enable = true;
        package = config.flake.packages.${pkgs.system}.niri-wrapped;
      };

      # niri's recommended portal: gnome backend (handles screencast etc.).
      # Common scaffolding (xdg.portal.enable, default config) comes from
      # workstation-common.
      xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
    };
}
