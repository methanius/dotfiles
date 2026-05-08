# Centralised nixpkgs construction for the dendritic pattern.
#
# Declares the `flake.dendritic.overlays` option as a list-typed accumulator.
# Per-tool flake-parts modules (e.g. modules/flake/home/editor-neovim.nix)
# append their overlays to this list, and `perSystem._module.args.pkgs` is
# built once from the accumulated set.
#
# This is "option α" from the migration plan: avoid the multi-file
# `_module.args.pkgs` collision that arises when several modules try to
# define pkgs directly.
{
  lib,
  inputs,
  config,
  ...
}:
{
  options.flake.dendritic.overlays = lib.mkOption {
    type = lib.types.listOf (
      lib.mkOptionType {
        name = "overlay";
        check = builtins.isFunction;
      }
    );
    default = [ ];
    description = ''
      Accumulated nixpkgs overlays contributed by per-tool flake-parts
      modules. Read by perSystem to build a single `pkgs` shared by all
      home-manager and NixOS configurations.
    '';
  };

  config.perSystem =
    { system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = config.flake.dendritic.overlays;
        config.allowUnfree = true;
      };
    };
}
