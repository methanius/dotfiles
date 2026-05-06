# Builds the standalone Home-Manager outputs.
#
# Each host composes self.homeModules.default (the cross-host aggregator)
# with its host-specific HM module from ./hosts/<host>/home.nix.
{
  self,
  inputs,
  withSystem,
  ...
}: {
  flake.homeConfigurations."clausormann@wsl" = withSystem "x86_64-linux" ({pkgs, ...}:
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        repoPath = "/home/clausormann/dotfiles";
      };
      modules = [
        self.homeModules.default
        ../../hosts/wsl/home.nix
        {
          home = {
            username = "clausormann";
            homeDirectory = "/home/clausormann";
          };
        }
      ];
    });
}
