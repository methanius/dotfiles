# NixOS configuration for the home machine ("nixos").
#
# Single source of truth for "which roles does this host get and which user
# runs HM here". Adding another NixOS host = another file in this directory
# following the same shape.
{
  config,
  inputs,
  withSystem,
  ...
}:
let
  # Captured from flake-parts top-level so the inner NixOS module can hand
  # them to home-manager.users.<user>.imports without trying to read
  # `config.flake.*` from inside a NixOS module (different scope).
  hmBase = config.flake.modules.homeManager.base;
  hmWorkstationUser = config.flake.modules.homeManager.workstation-niri-user;
in
{
  flake.nixosConfigurations.nixos = withSystem "x86_64-linux" (
    { pkgs, ... }:
    inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        # Reuse the perSystem pkgs (with overlays + allowUnfree) instead of
        # re-importing nixpkgs inside the NixOS module set.
        { nixpkgs.pkgs = pkgs; }

        # Roles + host-specific bits.
        config.flake.modules.nixos.base
        config.flake.modules.nixos.workstation-niri
        config.flake.modules.nixos.host-nixos

        # Home-Manager as a NixOS module, attaching the user's HM role bundle
        # (base + workstation-user) and forwarding the shared `my.*` transport
        # options from NixOS scope into HM scope.
        inputs.home-manager.nixosModules.home-manager
        (
          { config, ... }:
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "hm-backup";
              users.${config.my.user.name}.imports = [
                hmBase
                hmWorkstationUser
                {
                  my.repoPath = config.my.repoPath;
                  my.editor.neovim.extraRuntimePackages = config.my.editor.neovim.extraRuntimePackages;
                }
              ];
            };
          }
        )
      ];
    }
  );
}
