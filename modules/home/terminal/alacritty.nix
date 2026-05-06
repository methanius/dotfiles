{
  config,
  repoPath,
  ...
}: {
  xdg.configFile."alacritty".source =
    config.lib.file.mkOutOfStoreSymlink "${repoPath}/config/alacritty";
}
