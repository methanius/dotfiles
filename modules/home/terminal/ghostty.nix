{
  config,
  repoPath,
  ...
}: {
  xdg.configFile."ghostty".source =
    config.lib.file.mkOutOfStoreSymlink "${repoPath}/config/ghostty";
}
