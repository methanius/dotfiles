# Ghostty terminal — workstation-user role contribution.
#
# This is the first file migrated to the strict dendritic pattern (C03).
# It contributes a Home-Manager module fragment to the
# `flake.modules.homeManager.workstation-user` named module via
# flake-parts' modules namespace (added in C01).
#
# At evaluation time, every file that targets the same
# `flake.modules.homeManager.workstation-user` attribute is module-merged into
# a single composite module. Hosts then import that composite module to pull
# in the entire workstation-user toolchain as a unit.
{
  flake.modules.homeManager.workstation-user =
    {
      pkgs,
      config,
      ...
    }:
    {
      home.packages = [ pkgs.ghostty ];
      xdg.configFile."ghostty".source =
        config.lib.file.mkOutOfStoreSymlink "${config.my.repoPath}/config/ghostty";
    };
}
