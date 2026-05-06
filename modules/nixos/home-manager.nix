# Wires Home-Manager into NixOS as a module, feeding it the same
# self.homeModules.default aggregator that the standalone WSL build uses.
#
# Add NixOS-only HM extras (e.g. self.homeModules.desktop) to
# users.clausormann.imports below as the desktop config evolves.
{
  inputs,
  self,
  ...
}: {
  imports = [inputs.home-manager.nixosModules.home-manager];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hm-backup";
    extraSpecialArgs = {
      repoPath = "/home/clausormann/dotfiles";
    };
    users.clausormann.imports = [
      self.homeModules.default
      # self.homeModules.desktop  # enable when desktop config is ready
    ];
  };
}
