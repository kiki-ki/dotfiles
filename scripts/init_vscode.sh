#!/bin/sh

init_settings () {
  local source_dir="$HOME"/.config/vscode
  local deploy_dir="$HOME"/Library/Application\ Support/Code/User/

  cat "$source_dir"/settings.json > "$deploy_dir"/settings.json
  cat "$source_dir"/keybindings.json > "$deploy_dir"/keybindings.json

  while read -r line; do code --install-extension "$line"; done < "$source_dir"/extensions.txt
}

echo "VSCode settings overwrite current VSCode settings, OK? [Yy/n]: "
read -r yn

if [ ! "$yn" = "Y" ] && [ ! "$yn" = "y" ]; then
  echo "canceled."
  exit 1
fi

init_settings
echo "init vscode settings completed."

