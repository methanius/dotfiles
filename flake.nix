{
    description = "My first Home Manager flake";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    };

    outputs = { nixpkgs, home-manager, neovim-nightly-overlay, ... }:
    let
        system = "x86_64-linux";
        username = builtins.replaceStrings ["\n"] [""] (builtins.readFile ./username.nix);
    in
        {
            packages.${system}.default = home-manager.defaultPackage.${system};
            homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
                    pkgs = import nixpkgs { inherit system;
                        overlays = [
                            neovim-nightly-overlay.overlay
                            ];
                        };
                    modules = [ ./home.nix ];
                };
        };
}
