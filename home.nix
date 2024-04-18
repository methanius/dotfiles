{pkgs, ...}: {
    home.username = "claus";
    home.homeDirectory = "/home/claus";
    home.stateVersion = "22.11";
    home.packages = [
        pkgs.ripgrep
    ];

    programs.home-manager.enable = true;
}
