# Noctalia desktop shell — workstation-niri-user HM role.
#
# Vimjoyer-style flow: install Noctalia declaratively but configure it
# imperatively through Noctalia's own setup wizard / settings UI. The
# config directory `~/.config/noctalia/` is live-symlinked to
# `${repoPath}/config/noctalia/`, so any changes Noctalia makes to its
# JSON state (settings.json, colors.json, plugins.json, user-templates.toml,
# plugins/<name>/settings.json) land directly in the repo working tree.
# The user reviews them with `jj diff` and commits the bits they want
# tracked. Individual JSON fields can be hand-restored or pruned the same
# way.
#
# We do NOT set programs.noctalia-shell.{settings,colors,plugins,user-templates}
# — those would have HM write generated JSON into ~/.config/noctalia/, which
# would collide with the directory-level symlink. Leaving them at default
# `{}` keeps the HM module purely package-installing here. This is the
# point of the Vimjoyer flow: the package install is declarative, the
# config is imperative-but-tracked.
#
# Replaces the sway stack's per-tool HM modules (waybar, fuzzel, swaylock,
# swayidle, swww wallpaper rotation) on niri hosts. Those tools remain
# wired into the `workstation-user` role for the sway stack.
#
# Quickshell substitution: Noctalia's flake builds Quickshell from source
# via the `noctalia-qs` subflake. That source build is in *no* public
# binary cache (not cache.nixos.org, not niri.cachix.org), so taking it
# verbatim forces a from-scratch Quickshell compile (~10 min C++/Qt) on
# every host. nixpkgs ships its own `pkgs.quickshell` that *is* in
# cache.nixos.org. Noctalia's `nix/package.nix` accepts `quickshell` as a
# `callPackage` arg, so we override it to the nixpkgs build via
# `.override`. This trades upstream's "we tested with this exact qs
# version" guarantee for cache-served builds; if a future Noctalia bump
# requires features absent from nixpkgs's qs, drop this override and
# accept the rebuild.
{ inputs, ... }:
{
  flake.modules.homeManager.workstation-niri-user =
    {
      pkgs,
      config,
      ...
    }:
    let
      noctaliaWithCachedQs =
        (inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default).override
          {
            quickshell = pkgs.quickshell;
          };
    in
    {
      imports = [ inputs.noctalia.homeModules.default ];

      programs.noctalia-shell = {
        enable = true;
        package = noctaliaWithCachedQs;
      };

      # Live symlink: Noctalia's own writes land in the repo working tree.
      xdg.configFile."noctalia".source =
        config.lib.file.mkOutOfStoreSymlink "${config.my.repoPath}/config/noctalia";
    };
}
