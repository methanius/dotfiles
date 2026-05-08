# Cross-host NixOS base aggregator. Anything that should be on every NixOS
# machine this flake configures lives here (or under a sibling file imported
# from this aggregator).
{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./_options.nix
    ./home-manager.nix
  ];

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
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

  nixpkgs.config.allowUnfree = true;

  users.users.${config.my.user.name} = {
    isNormalUser = true;
    description = config.my.user.name;
    extraGroups = ["wheel" "networkmanager" "video" "audio"];
    shell = pkgs.zsh;
  };

  # Required by NixOS when a user's shell is set to zsh from nixpkgs.
  programs.zsh.enable = true;
}
