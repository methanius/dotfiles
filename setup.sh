#!/bin/sh

echo "Starting setup scripts!"

# Make sure nix is installed
if nix --help >/dev/null 2>&1; then
    echo "Nix is already installed! Moving on."
    nix-channel --update
    . /home/claus/.nix-profile/etc/profile.d/nix.sh
else
    curl -L https://nixos.org/nix/install -o install.sh
    sh install.sh
    nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
    nix-channel --add https://nixos.org/channels/nixpkgs-unstable unstable
    nix-channel --update
    . /home/claus/.nix-profile/etc/profile.d/nix.sh
fi

# Check Nix config file exists
NIXDIR="$HOME/.config/nix"
if [ -d "$NIXDIR" ]; then
    echo "Nix config directory exists!"
else
    mkdir "$NIXDIR" -p
fi

# Make sure we have home manager
NIXCONF="$NIXDIR/nix.conf"
if [ ! -f "$NIXCONF" ]; then
    echo "Didn't find $NIXCONF, touching file"
    touch "$NIXCONF"
fi

FLAKE_EXPERIMENTAL_LINE="experimental-features = nix-command flakes"
if ! grep "$FLAKE_EXPERIMENTAL_LINE" < "$NIXCONF" >/dev/null 2>&1;
then
    echo "Didn't find flakes enabled in $NIXCONF, enabling..."
    echo "$FLAKE_EXPERIMENTAL_LINE" | cat >> "$NIXCONF"
fi

# Build the damn thing
nix run . -- build --flake .
home-manager switch --flake .

