{pkgs, ...}: {
  home.packages = [
    pkgs.cargo
    pkgs.go
    pkgs.nodejs
    pkgs.perl
    pkgs.uv
    pkgs.zig

    pkgs.delta
    pkgs.fd
    pkgs.ripgrep
    pkgs.dust
    pkgs.ripdrag

    pkgs.jujutsu
    pkgs.mergiraf
    pkgs.gh
    pkgs.opencode
  ];

  programs = {
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
    lazygit.enable = true;
    pandoc.enable = true;
    bat = {
      enable = true;
      themes = {
        kanagawa = {
          src = ../../../config/bat;
          file = "kanagawa.tmTheme";
        };
      };
      config = {
        theme = "kanagawa";
      };
    };
  };
}
