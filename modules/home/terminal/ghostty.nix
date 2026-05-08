{
  pkgs,
  config,
  ...
}: {
  home.packages = [pkgs.ghostty];
  xdg.configFile."ghostty".source =
    config.lib.file.mkOutOfStoreSymlink "${config.my.repoPath}/config/ghostty";
}
