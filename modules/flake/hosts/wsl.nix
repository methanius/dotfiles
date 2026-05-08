# Standalone Home-Manager configuration for the WSL host.
#
# Single source of truth for "who runs HM on WSL". The actual content lives
# in role/host modules under flake.modules.homeManager.{base,
# workstation-user, host-wsl} and is composed here.
{
  config,
  inputs,
  withSystem,
  ...
}:
{
  flake.homeConfigurations."clausormann@wsl" = withSystem "x86_64-linux" (
    { pkgs, ... }:
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        config.flake.modules.homeManager.base
        config.flake.modules.homeManager.workstation-user
        config.flake.modules.homeManager.host-wsl
      ];
    }
  );
}
