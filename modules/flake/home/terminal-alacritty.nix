# Alacritty terminal — workstation-user role contribution.
{
  flake.modules.homeManager.workstation-user =
    {
      pkgs,
      config,
      ...
    }:
    {
      home.packages = [ pkgs.alacritty ];
      xdg.configFile."alacritty".source =
        config.lib.file.mkOutOfStoreSymlink "${config.my.repoPath}/config/alacritty";
    };
}
