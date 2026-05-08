# NixOS base role — cross-host invariants for every NixOS machine.
#
# Anything that should be on every NixOS host this flake configures lives
# here or in a sibling file that also contributes to
# `flake.modules.nixos.base`.
{ config, ... }:
{
  flake.modules.nixos.base =
    {
      pkgs,
      config,
      ...
    }:
    {
      nix.settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        auto-optimise-store = true;

        # Extra binary caches. `extra-substituters`/`extra-trusted-public-keys`
        # append to the defaults (cache.nixos.org), so we don't have to restate
        # them. nix-community.cachix.org serves prebuilt artifacts for the
        # neovim-nightly-overlay input declared in flake.nix; without it every
        # overlay bump rebuilds neovim from source.
        extra-substituters = [
          "https://nix-community.cachix.org"
        ];
        extra-trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
      };

      # NOTE: nixpkgs.config.allowUnfree is intentionally NOT set here; the
      # external pkgs instance from modules/flake/nixpkgs.nix already carries
      # config.allowUnfree = true, and setting it again triggers the
      # "externally created instance" assertion in NixOS top-level.

      users.users.${config.my.user.name} = {
        isNormalUser = true;
        description = config.my.user.name;
        extraGroups = [
          "wheel"
          "networkmanager"
          "video"
          "audio"
        ];
        shell = pkgs.zsh;
      };

      # Required by NixOS when a user's shell is set to zsh from nixpkgs.
      programs.zsh.enable = true;
    };
}
