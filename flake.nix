{
  description = "Unified Nix configuration — home-manager + NixOS";

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

  outputs = {
    nixpkgs,
    home-manager,
    neovim-nightly-overlay,
    ...
  }: let
    system = "x86_64-linux";
    username = "clausormann";
    overlays = import ./overlays/default.nix {inherit neovim-nightly-overlay;};
    pkgs = import nixpkgs {
      inherit system;
      inherit overlays;
    };
  in {
    homeConfigurations."${username}@wsl" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        repoPath = "/home/${username}/dotfiles";
      };
      modules = [
        ./home/default.nix
        ./hosts/wsl/default.nix
        {
          home = {
            inherit username;
            homeDirectory = "/home/${username}";
          };
        }
      ];
    };

    # Placeholder: NixOS configuration with home-manager as a module
    # nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
    #   inherit system;
    #   modules = [
    #     ./hosts/nixos/default.nix
    #     home-manager.nixosModules.home-manager
    #     {
    #       nixpkgs.overlays = overlays;
    #       home-manager.useGlobalPkgs = true;
    #       home-manager.useUserPackages = true;
    #       home-manager.extraSpecialArgs = {
    #         repoPath = "/home/${username}/nix-config";
    #       };
    #       home-manager.users.${username} = import ./home/default.nix;
    #     }
    #   ];
    # };
  };
}
