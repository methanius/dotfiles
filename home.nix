{pkgs, ...}: {
    home.username = "claus";
    home.homeDirectory = "/home/claus";
    home.stateVersion = "22.11";

    programs.home-manager.enable = true;
}
