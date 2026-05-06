{
  pkgs,
  config,
  ...
}: {
  home.packages = [
    pkgs.neovim
    pkgs.selene
    pkgs.stylua
    pkgs.tree-sitter
  ];

  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.my.repoPath}/config/nvim";
}
