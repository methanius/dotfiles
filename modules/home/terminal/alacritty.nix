{config, ...}: {
  xdg.configFile."alacritty".source =
    config.lib.file.mkOutOfStoreSymlink "${config.my.repoPath}/config/alacritty";
}
