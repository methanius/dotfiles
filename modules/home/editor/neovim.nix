{
  pkgs,
  config,
  lib,
  ...
}: {
  programs.neovim = {
    enable = true;
    package = pkgs.neovim;
    extraPackages = config.my.editor.neovim.extraRuntimePackages;
  };

  # `programs.neovim` writes `~/.config/nvim/init.lua` whenever its
  # generated initLua is non-empty (which it is, even with no plugins/config,
  # because HM injects a default lua header). That collides with our
  # whole-directory symlink of ~/.config/nvim to the live repo, since HM
  # would then try to install init.lua *inside* an out-of-store path. Force
  # the file off; the live config provides its own init.lua via the symlink.
  xdg.configFile."nvim/init.lua".enable = lib.mkForce false;

  home.packages = [
    pkgs.selene
    pkgs.stylua
    pkgs.tree-sitter
  ];

  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.my.repoPath}/config/nvim";
}
