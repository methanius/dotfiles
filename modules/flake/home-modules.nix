# Registers Home-Manager modules under flake.homeModules.<name>.
#
# Hosts compose their HM config by combining `default` with host-specific
# extras, per the dendritic style C decision in the migration plan.
{ config, ... }:
{
  flake.homeModules = {
    default = ../home/default.nix;

    # Bridge: until NixOS migrates to consume `flake.modules.homeManager.*`
    # directly (C09), expose the workstation-user role here under the legacy
    # `homeModules.desktop` name so modules/nixos/home-manager.nix keeps
    # working unchanged.
    desktop = config.flake.modules.homeManager.workstation-user;
  };
}
