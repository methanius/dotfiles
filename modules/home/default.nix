{ pkgs, ... }:
{
  imports = [
    ./_options.nix
  ];

  programs.home-manager.enable = true;
  fonts.fontconfig.enable = true;

  home = {
    stateVersion = "26.05";
    sessionVariables.EDITOR = "nvim";
    packages = [
      pkgs.nerd-fonts.jetbrains-mono
      pkgs.nerd-fonts.victor-mono
    ];
  };
}
