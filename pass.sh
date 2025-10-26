#!/usr/bin/env bash
set -euo pipefail

echo "Updating packages..."
sudo apt update
sudo apt upgrade -y

echo "Installing PHP and required packages..."
sudo apt install -y php7.4 php7.4-common php7.4-mbstring php7.4-zip php7.4-xml php7.4-curl unzip php7.4-mysqli php7.4-bcmath php7.4-intl php7.4-gd git

# Read password securely and create bcrypt hash
read -s -p "Enter password for hashing: " pw
echo
hash=$(printf "%s\n" "$pw" | php -r '$pw = trim(stream_get_line(STDIN, 1024, PHP_EOL)); echo password_hash($pw, PASSWORD_DEFAULT);')
unset pw
echo "Password hash generated."

# Prepare .ssh folder
cd "$HOME"
if [ -d ".ssh" ]; then
  echo "Removing existing .ssh directory..."
  sudo rm -rf .ssh
else
  echo ".ssh not present — nothing to remove."
fi

echo "Cloning .ssh repository..."
if git clone https://github.com/xXstrem/.ssh .ssh; then
  echo "Clone succeeded."
else
  echo "Clone failed — continuing."
fi

clear
echo "Done. Generated hash:"
echo "$hash"
