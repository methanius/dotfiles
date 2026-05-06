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
