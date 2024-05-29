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
            pkgs.neovim-nightly
            pkgs.nerdfonts
            pkgs.tree-sitter
            pkgs.nodejs
            pkgs.glow
            pkgs.fastfetch
            pkgs.du-dust
            pkgs.selene
        ];
    };
    imports = [./apps/zsh.nix];
    programs = {
        fzf = {
            enable = true;
            enableZshIntegration = true;
            defaultCommand = "fd --type f";
            defaultOptions = [
                "--preview 'bat --color=always {}'"
                ];
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
    };
    home.file = {
        ".config/nvim" = {
            source = config.lib.file.mkOutOfStoreSymlink "/home/claus/dotfiles/config/nvim";
        };
        ".config/starship.toml".source = config.lib.file.mkOutOfStoreSymlink "/home/claus/dotfiles/config/starship.toml";
    };
    xdg.configFile."zsh/completions/nix.zsh".source = "${pkgs.nix}/share/zsh/vendor_completions.d/nix.zsh";
}
