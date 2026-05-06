{
  pkgs,
  config,
  ...
}: {
  home.packages = [
    pkgs.btop
    pkgs.htop
    pkgs.tealdeer
    pkgs.tree
    pkgs.bluetui
  ];

  programs = {
    fzf = {
      enable = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
      defaultCommand = "fd --type f";
      fileWidgetCommand = "fd --type f";
      fileWidgetOptions = ["--preview 'bat --color=always {}'"];
      changeDirWidgetCommand = "fd --type d";
      changeDirWidgetOptions = ["--preview 'tree -C {} | head -200'"];
    };
    atuin = {
      enable = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
    };
    eza = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
      git = true;
      icons = "auto";
    };
    yazi = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
    };
    zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
    };
    fastfetch.enable = true;
  };

  xdg.configFile."atuin".source =
    config.lib.file.mkOutOfStoreSymlink "${config.my.repoPath}/config/atuin";
  xdg.configFile."zsh/completions/nix.zsh".source = "${pkgs.nix}/share/zsh/vendor_completions.d/nix.zsh";
}
