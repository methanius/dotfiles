{ ... }:
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
  };

  xdg.configFile."starship.toml".source = ../../../config/starship.toml;
}
