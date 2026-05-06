{config, ...}: {
  xdg.configFile."ghostty".source =
    config.lib.file.mkOutOfStoreSymlink "${config.my.repoPath}/config/ghostty";
}
