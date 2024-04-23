{pkgs, config, ...}:
let 
    username = "claus";
    homeDirectory = "/home/${username}";
in
    {
    programs.home-manager.enable = true;
    targets.genericLinux.enable = true;
    home = {
        inherit username;
        inherit homeDirectory;
        stateVersion = "22.11";
        sessionVariables.EDITOR = "nvim";
        packages = [
            pkgs.ripgrep
            pkgs.sheldon
            pkgs.eza
            pkgs.bat
            pkgs.stylua
            pkgs.neovim-nightly
        ];
    };
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
    };
    home.file = {
        ".config/nvim" = {
            source = config.lib.file.mkOutOfStoreSymlink "/home/claus/dotfiles/config/nvim";
        recursive=true;
        };
        ".config/starship.toml".source = config.lib.file.mkOutOfStoreSymlink "/home/claus/dotfiles/config/starship.toml";
    };
}
