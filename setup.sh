#!/bin/bash

if ! cat ./username.nix >/dev/null 2>&1; then  
    echo "No username.nix present, please create one with your system username!"
    exit 1
fi

echo "Starting setup scripts!"
if curl --help >/dev/null 2>&1; then
    echo "Curl already exists."
else
    sudo apt install curl
fi

# Make sure nix is installed
if nix --help >/dev/null 2>&1; then
    echo "Nix is already installed! Moving on."
    nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
    nix-channel --add https://nixos.org/channels/nixpkgs-unstable unstable
    nix-channel --update
    . /home/$(cat username.nix)/.nix-profile/etc/profile.d/nix.sh
else
    sh <(curl -L https://nixos.org/nix/install) --no-daemon 
    . /home/$(cat username.nix)/.nix-profile/etc/profile.d/nix.sh
    nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
    nix-channel --add https://nixos.org/channels/nixpkgs-unstable unstable
    nix-channel --update
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

nix-env -iA cachix -f https://cachix.org/api/v1/install
cachix use nix-community


# Build the damn thing
git add username.nix
nix run . -- build --flake .
./result/activate
home-manager switch --flake .
git restore --staged username.nix
