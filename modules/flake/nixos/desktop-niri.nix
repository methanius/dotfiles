# Niri scrollable-tiling Wayland compositor — NixOS-side workstation-niri role.
#
# Three contributions in one file:
#
#   1. `perSystem.packages.niri-wrapped` (exposed at flake level via
#      flake-parts as `flake.packages.<system>.niri-wrapped`) — a
#      `symlinkJoin` that bundles `niri` with all the runtime CLIs the
#      compositor shells out to (xwayland-satellite, screenshot and
#      clipboard tools, brightness and media controls, libnotify). The
#      `niri` binary is wrapped with `makeWrapper` so its PATH is hermetic
#      at exec time, regardless of what the user has in `home.packages`.
#      Mirrors the wrapping pattern already used by `programs.neovim` here.
#
#      The base `niri` and `xwayland-satellite` are pulled from the
#      niri-flake outputs (`niri-stable`, `xwayland-satellite-stable`)
#      rather than nixpkgs, because `niri.cachix.org` ships prebuilt
#      binaries for those exact derivations. Nixpkgs's `pkgs.niri` is
#      *not* in cache.nixos.org for fresh releases, which means using it
#      forces a ~10-minute Rust compile on every host that pulls a new
#      nixpkgs. Going through the flake's cache avoids that entirely.
#
#   2. `flake.modules.nixos.workstation-niri` — system-side enable for niri.
#      Composes `workstation-common` for the bits shared with the sway stack
#      (audio, portal scaffolding, GDM, printing). The HM-side config
#      (keybinds, settings) lives in `modules/flake/home/desktop-niri.nix`
#      contributing to the `workstation-niri-user` HM role. This module
#      also declares `niri.cachix.org` as a trusted substituter so the
#      cached prebuilds are actually fetched.
{ config, inputs, ... }:
{
  perSystem =
    { pkgs, lib, ... }:
    let
      niriBase = inputs.niri-flake.packages.${pkgs.stdenv.hostPlatform.system}.niri-stable;
      xwaylandSatellite =
        inputs.niri-flake.packages.${pkgs.stdenv.hostPlatform.system}.xwayland-satellite-stable;
      runtimeDeps =
        with pkgs;
        [
          grim
          slurp
          wl-clipboard
          brightnessctl
          playerctl
          pamixer
          libnotify
        ]
        ++ [ xwaylandSatellite ];
    in
    {
      packages.niri-wrapped = pkgs.symlinkJoin {
        name = "niri-wrapped";
        paths = [ niriBase ] ++ runtimeDeps;
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/niri \
            --prefix PATH : ${lib.makeBinPath runtimeDeps}
        '';
        # Propagate the session-package contract that NixOS's
        # `services.displayManager.sessionPackages` requires. `symlinkJoin`
        # drops `passthru` from the inputs, so we re-state it here mirroring
        # upstream `niri.passthru.providedSessions`.
        passthru.providedSessions = [ "niri" ];
      };
    };

  flake.modules.nixos.workstation-niri =
    { pkgs, ... }:
    {
      imports = [ config.flake.modules.nixos.workstation-common ];

      # Trust niri-flake's cachix so the prebuilt `niri-stable` and
      # `xwayland-satellite-stable` derivations referenced by
      # `niri-wrapped` are substituted instead of compiled locally.
      # Public key from the niri-flake README.
      nix.settings = {
        substituters = [ "https://niri.cachix.org" ];
        trusted-public-keys = [
          "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
        ];
      };

      programs.niri = {
        enable = true;
        package = config.flake.packages.${pkgs.stdenv.hostPlatform.system}.niri-wrapped;
      };

      # niri's recommended portal: gnome backend (handles screencast etc.).
      # Common scaffolding (xdg.portal.enable, default config) comes from
      # workstation-common.
      xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
    };
}
