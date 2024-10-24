{pkgs, config, ...}:
let 
    username = builtins.replaceStrings ["\n"] [""] (builtins.readFile ./username.nix);
    homeDirectory = "/home/${username}";
in
    {
    programs.home-manager.enable = true;
    targets.genericLinux.enable = true;
    home = {
        inherit username;
        inherit homeDirectory;
        stateVersion = "23.11";
        sessionVariables.EDITOR = "nvim";
        packages = [
            pkgs.bat
            pkgs.btop
            pkgs.cargo
            pkgs.delta
            pkgs.du-dust
            pkgs.fd
            pkgs.feh
            pkgs.glow
            pkgs.go
            pkgs.htop
            pkgs.neovim
            pkgs.nerdfonts
            pkgs.nodejs
            pkgs.perl
            pkgs.picom
            pkgs.ripdrag
            pkgs.ripgrep
            pkgs.rofi
            pkgs.selene
            pkgs.stylua
            pkgs.tldr
            pkgs.tree
            pkgs.tree-sitter
        ];
    };
    imports = [./apps/fish.nix ./apps/zsh.nix];
    programs = {
        fzf = {
            enable = true;
            enableZshIntegration = true;
            enableFishIntegration = true;
            defaultCommand = "fd --type f";
            fileWidgetCommand = "fd --type f";
            fileWidgetOptions = [ "--preview 'bat --color=always {}'" ];
            changeDirWidgetCommand = "fd --type d";
            changeDirWidgetOptions = [ "--preview 'tree -C {} | head -200'"];
        };
        starship = {
            enable = true;
            enableZshIntegration = true;
            enableFishIntegration = true;
        };
        atuin = {
            enable = true;
            enableZshIntegration = true;
            enableFishIntegration = true;
        };
        direnv = {
            enable = true;
            enableZshIntegration = true;
            nix-direnv.enable = true;
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
        lazygit = {
            enable = true;
        };
        pandoc = {
            enable = true;
        };
        fastfetch = {
            enable = true;
        };
    };
    xdg.configFile."starship.toml".source = ./config/starship.toml;
    xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink (builtins.toPath "${homeDirectory}/dotfiles/config/nvim");
    xdg.configFile."wezterm".source = config.lib.file.mkOutOfStoreSymlink (builtins.toPath "${homeDirectory}/dotfiles/config/wezterm");
    xdg.configFile."alacritty".source = config.lib.file.mkOutOfStoreSymlink (builtins.toPath "${homeDirectory}/dotfiles/config/alacritty");
    xdg.configFile."zsh/completions/nix.zsh".source = "${pkgs.nix}/share/zsh/vendor_completions.d/nix.zsh";
    xdg.configFile."polybar".source = ./config/polybar;
    xdg.configFile."picom".source = config.lib.file.mkOutOfStoreSymlink (builtins.toPath "${homeDirectory}/dotfiles/config/picom");
    xdg.configFile."i3".source = ./config/i3;
    xdg.configFile."rofi".source = ./config/rofi;
    xdg.configFile."rotating_wallpapers.sh".source = ./config/rotating_wallpaper.sh;
    xdg.configFile."wallpapers".source = ./config/wallpapers;
}
