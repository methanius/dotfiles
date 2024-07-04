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
            pkgs.ripgrep
            pkgs.bat
            pkgs.stylua
            pkgs.neovim
            pkgs.nerdfonts
            pkgs.tree-sitter
            pkgs.nodejs
            pkgs.glow
            pkgs.fastfetch
            pkgs.du-dust
            pkgs.selene
            pkgs.delta
            pkgs.fd
            pkgs.tree
            pkgs.cargo
            pkgs.go
            pkgs.perl
            pkgs.htop
            pkgs.shellcheck
            pkgs.ripdrag
            pkgs.tldr
            pkgs.btop
            pkgs.rofi
            pkgs.polybar
            pkgs.picom
            pkgs.feh
        ];
    };
    imports = [./apps/zsh.nix];
    programs = {
        fzf = {
            enable = true;
            enableZshIntegration = true;
            defaultCommand = "fd --type f";
            fileWidgetCommand = "fd --type f";
            fileWidgetOptions = [ "--preview 'bat --color=always {}'" ];
            changeDirWidgetCommand = "fd --type d";
            changeDirWidgetOptions = [ "--preview 'tree -C {} | head -200'"];
        };
        starship = {
            enable = true;
            enableZshIntegration = true;
        };
        atuin = {
            enable = true;
            enableZshIntegration = true;
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
            git = true;
            icons = true;
        };
        yazi = {
            enable = true;
            enableBashIntegration = true;
            enableZshIntegration = true;
        };
        zoxide = {
            enable = true;
            enableBashIntegration = true;
            enableZshIntegration = true;
        };
        pandoc = {
            enable = true;
        };
    };
    xdg.configFile."starship.toml".source = ./config/starship.toml;
    xdg.configFile."nvim".source = ./config/nvim;
    xdg.configFile."wezterm".source = ./config/wezterm;
    xdg.configFile."zsh/completions/nix.zsh".source = "${pkgs.nix}/share/zsh/vendor_completions.d/nix.zsh";
    xdg.configFile."polybar".source = ./config/polybar;
    xdg.configFile."picom".source = ./config/picom;
    xdg.configFile."i3".source = ./config/i3;
    xdg.configFile."rofi".source = ./config/rofi;
    xdg.configFile."rotating_wallpapers.sh".source = ./config/rotating_wallpaper.sh;
    xdg.configFile."wallpapers".source = ./config/wallpapers;
}
