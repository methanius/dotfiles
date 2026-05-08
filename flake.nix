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
  };

  # Dendritic pattern: every flake-parts module lives under ./modules/flake
  # and is auto-discovered by import-tree. The repo's plain HM/NixOS modules
  # (./modules/home, ./modules/nixos, ./hosts) are intentionally outside the
  # import-tree scope; they are referenced by file path from the flake-parts
  # modules that build homeConfigurations / nixosConfigurations.
  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.flake-parts.flakeModules.modules
        (inputs.import-tree ./modules/flake)
      ];
    };
}
