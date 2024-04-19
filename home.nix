{pkgs, ...}: {
    programs.home-manager.enable = true;
    targets.genericLinux.enable = true;
    home.username = "claus";
    home.homeDirectory = "/home/claus";
    home.stateVersion = "22.11";
    home.packages = [
        pkgs.ripgrep
        pkgs.sheldon
        pkgs.eza
        pkgs.bat
        pkgs.stylua
    ];
    programs = {
        zsh = {
            enable = true;
            autosuggestion = {
                enable = true;
            };
            completionInit = "autoload -Uz compinit";
            defaultKeymap = "vicmd";
            history = {
                expireDuplicatesFirst = true;
                extended = true;
                ignoreDups = true;
                ignoreSpace = true;
                save = 100000;
                share = true;
                size = 100000;
            };
            shellAliases = {
                vi = "nvim";
                vim = "nvim";
                go = "xdg-open";
                ls = "eza";
                cat = "bat";
            };
        };
        atuin = {
            enable = true;
            enableZshIntegration = true;
        };
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
    };
}
