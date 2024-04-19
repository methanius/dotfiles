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
