# Exposes a perSystem `pkgs` with project overlays applied.
# Both home-manager and NixOS configurations consume this so the overlay set
# is configured in exactly one place.
{inputs, ...}: {
  perSystem = {system, ...}: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      overlays = import ../../overlays/default.nix {
        inherit (inputs) neovim-nightly-overlay;
      };
      config.allowUnfree = true;
    };
  };
}
