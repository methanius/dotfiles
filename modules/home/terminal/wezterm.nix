{
  config,
  repoPath,
  ...
}: {
  xdg.configFile."wezterm".source =
    config.lib.file.mkOutOfStoreSymlink "${repoPath}/config/wezterm";
}
