{
    description = "My first Home Manager flake";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { nixpkgs, home-manager, ... }:
    let
        system = "x86_64-linux";
    in
        {
        defaultPackage.${system} = home-manager.defaultPackage.${system};

        homeConfigurations = {
            "claus" = home-manager.lib.homeManagerConfiguration {
                pkgs = import nixpkgs { inherit system; };

                modules = [ ./home.nix ];
            };
        };
    };
}
