# Wires Home-Manager into NixOS as a module, feeding it the same
# self.homeModules.default aggregator that the standalone WSL build uses.
#
# `my.repoPath` is set per host inside hosts/<host>/system.nix and flows
# into the HM module set automatically because useGlobalPkgs/useUserPackages
# share the NixOS-side option scope.
#
# Add NixOS-only HM extras (e.g. self.homeModules.desktop) to the user's
# imports list below as the desktop config evolves.
{
  inputs,
  self,
  config,
  ...
}: {
  imports = [inputs.home-manager.nixosModules.home-manager];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hm-backup";
    users.${config.my.user.name}.imports = [
      self.homeModules.default
      # self.homeModules.desktop  # enable when desktop config is ready
      # Forward the NixOS-level my.repoPath into HM scope so HM modules that
      # consume `config.my.repoPath` (mkOutOfStoreSymlink consumers) work.
      {my.repoPath = config.my.repoPath;}
    ];
  };
}
