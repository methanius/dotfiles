# Home-Manager base role — invariants for every user this flake configures.
{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.home-manager.enable = true;
      fonts.fontconfig.enable = true;

      home = {
        stateVersion = "26.05";
        sessionVariables.EDITOR = "nvim";
        packages = [
          pkgs.nerd-fonts.jetbrains-mono
          pkgs.nerd-fonts.victor-mono
        ];
      };
    };
}
