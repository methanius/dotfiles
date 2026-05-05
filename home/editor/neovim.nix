{
  pkgs,
  config,
  repoPath,
  ...
}: {
  home.packages = [
    pkgs.neovim
    pkgs.selene
    pkgs.stylua
    pkgs.tree-sitter
  ];

  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${repoPath}/config/nvim";
}
