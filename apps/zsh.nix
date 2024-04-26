{pkgs, ... }:
{
    programs.zsh = {
        enable = true;
        autosuggestion = {
            enable = true;
        };
        syntaxHighlighting = {
            enable = true;
        };
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
}
