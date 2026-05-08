# Registers every plain Home-Manager module in modules/home/ as a named entry
# under flake.homeModules.<dotted.path>, plus a `default` aggregator that the
# existing modules/home/default.nix provides.
#
# Hosts compose their HM config by combining `default` with host-specific
# extras, per the dendritic style C decision in the migration plan.
{
  flake.homeModules = {
    default = ../home/default.nix;

    programs = ../home/programs.nix;

    "editor.neovim" = ../home/editor/neovim.nix;

    dev = ../home/dev/default.nix;
    desktop = ../home/desktop/default.nix;
  };
}
