{
    description = "My first Home Manager flake";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = inputs@{ nixpkgs, home-manager, ... }: {
        defaultPackage.x86_64-linux = home-manager.defaultPackage.x86_64-linux;

        homeConfigurations = {
            "claus" = inputs.home-manager.lib.homeManagerConfiguration { 
                system = "x86_64-linux";
                homeDirectory = "/home/claus";
                username = "claus";
                configuration.imports = [ ./home.nix ];
            };
        };
    };
}
