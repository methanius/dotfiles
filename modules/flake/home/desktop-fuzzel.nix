# Fuzzel application launcher — workstation-user role.
#
# Live-symlinked config so palette/font edits apply without HM rebuild.
{
  flake.modules.homeManager.workstation-user =
    {
      pkgs,
      config,
      ...
    }:
    {
      home.packages = [ pkgs.fuzzel ];

      xdg.configFile."fuzzel/fuzzel.ini".source =
        config.lib.file.mkOutOfStoreSymlink "${config.my.repoPath}/config/fuzzel/fuzzel.ini";
    };
}
