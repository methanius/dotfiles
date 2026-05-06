{config, ...}: {
  xdg.configFile."wezterm".source =
    config.lib.file.mkOutOfStoreSymlink "${config.my.repoPath}/config/wezterm";
}
