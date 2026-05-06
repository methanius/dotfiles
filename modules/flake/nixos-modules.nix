# Registers plain NixOS modules in modules/nixos/ as flake.nixosModules.<name>.
# The `default` aggregator pulls in everything that should land on every host.
{
  flake.nixosModules = {
    default = ../nixos/default.nix;
    home-manager = ../nixos/home-manager.nix;
  };
}
