{
  description = "Dendritic dotfiles — Home-Manager + NixOS via flake-parts";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # Strict dendritic pattern: every flake-parts module lives under
  # ./modules/flake and is auto-discovered by import-tree. The legacy
  # ./modules/home, ./modules/nixos plain-module trees and ./hosts/<host>/
  # are gone — every tool/role/host is now a flake-parts module
  # contributing to flake.modules.<class>.<role> via
  # flake-parts.flakeModules.modules.
  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.flake-parts.flakeModules.modules
        (inputs.import-tree ./modules/flake)
      ];
    };
}
