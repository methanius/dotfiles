# Builds nixosConfigurations.<host>. Each host pulls the cross-host
# self.nixosModules.default plus its own ./hosts/<host>/system.nix and
# hardware-configuration.nix.
{
  self,
  inputs,
  withSystem,
  ...
}:
{
  flake.nixosConfigurations.nixos = withSystem "x86_64-linux" (
    { pkgs, ... }:
    inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs self; };
      modules = [
        # Reuse the perSystem pkgs (with overlays + allowUnfree) instead of
        # re-importing nixpkgs inside the NixOS module set.
        { nixpkgs.pkgs = pkgs; }

        self.nixosModules.default
        ../../hosts/nixos/system.nix
        ../../hosts/nixos/hardware-configuration.nix
      ];
    }
  );
}
