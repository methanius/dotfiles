# NixOS server role — headless machines (Optiplex, Pi).
#
# Placeholder for future server-class hosts. Currently empty; the role is
# declared so future per-tool modules can contribute to it (e.g. a
# tailscale module that targets both `workstation` and `server`), and so
# downstream host files can `imports = [ ... config.flake.modules.nixos.server ]`
# without errors before any contributing module exists.
{
  flake.modules.nixos.server = { ... }: { };
}
