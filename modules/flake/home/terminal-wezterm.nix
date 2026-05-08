# Wezterm terminal — workstation-user role contribution.
{
  flake.modules.homeManager.workstation-user =
    {
      pkgs,
      config,
      ...
    }:
    {
      home.packages = [ pkgs.wezterm ];
      xdg.configFile."wezterm".source =
        config.lib.file.mkOutOfStoreSymlink "${config.my.repoPath}/config/wezterm";
    };
}
