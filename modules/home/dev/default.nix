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
    # opencode: installed outside Nix via the official installer
    # (`curl -fsSL https://opencode.ai/install | bash`), which drops the
    # binary at ~/.opencode/bin/opencode. We symlink it into ~/.local/bin/
    # (already on PATH via hosts/wsl/home.nix) so `opencode` resolves.
    #
    # The nixpkgs build of opencode segfaults inside ld-linux against
    # glibc 2.42 (upstream packaging issue); the official binary pins its
    # own runtime and works against system glibc on WSL or via
    # programs.nix-ld on NixOS. Re-add `pkgs.opencode` here if/when
    # nixpkgs ships a fixed version.
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
