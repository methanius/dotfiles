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
            syntaxHighlighting = {
                enable = true;
            };
            completionInit = "autoload -Uz compinit";
            defaultKeymap = "vicmd";
            autocd = true;
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
            plugins = [
            {
                name = "zsh-expand";
                src = pkgs.fetchFromGitHub {
                    owner = "MenkeTechnologies";
                    repo = "zsh-expand";
                    rev = "v5.2.0";
                    sha256 = "sha256-pcYYTQsh2c57U7kVYgCDMi7Z4lAjncQzapfPpTRgKZI=";
                };
            }
            ];
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
