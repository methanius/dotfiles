{pkgs, ...}: {
    programs.home-manager.enable = true;
    targets.genericLinux.enable = true;
    home.username = "claus";
    home.homeDirectory = "/home/claus";
    home.stateVersion = "22.11";
    home.packages = [
        pkgs.ripgrep
        pkgs.starship
        pkgs.sheldon
        pkgs.eza
        pkgs.bat
        pkgs.stylua
    ];
    programs = {
        atuin = {
            enable = true;
        };
        fzf = {
            enable = true;
            enableZshIntegration = true;
        };
    };
}
