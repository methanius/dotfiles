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
      self.homeModules.desktop
      # Forward NixOS-level options into HM scope so HM modules that consume
      # them (mkOutOfStoreSymlink consumers, wrapped-nvim extraPackages) work.
      {
        my.repoPath = config.my.repoPath;
        my.editor.neovim.extraRuntimePackages = config.my.editor.neovim.extraRuntimePackages;
      }
    ];
  };
}
