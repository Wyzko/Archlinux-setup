#!/bin/zsh

# Ce fichier permet d'installer zsh et d'en faire le shell par défaut.
# Il permet aussi d'installer Zim, pour personnaliser zsh

# installation de Zsh
sudo pacman -S zsh

# lancement de Zsh
zsh

# installation de Zim
git clone --recursive https://github.com/zimfw/zimfw.git ${ZDOTDIR:-${HOME}}/.zim

# configuration de Zim
setopt EXTENDED_GLOB
for template_file ( ${ZDOTDIR:-${HOME}}/.zim/templates/* ); do
  user_file="${ZDOTDIR:-${HOME}}/.${template_file:t}"
  touch ${user_file}
  ( print -rn "$(<${template_file})$(<${user_file})" >! ${user_file} ) 2>/dev/null
done

# Zsh comme shell par défaut
chsh -s /bin/zsh benjamin # changer benjamin par le nom compte
chsh -s /bin/zsh # zsh comme shell par défaut pour root (thème par défaut)

# finalisation de la configuration
echo "Pour finaliser la configuration, lancer la commande suivante:"
echo "-- source \${ZDOTDIR:-\${HOME}}/.zlogin -- dans un nouveau terminal."

echo "Un redémarrage est nécessaire pour prendre en compte le changement de shell."
echo "Pour changer de thème, modifier \"zprompt_theme='pure'\" dans le fichier \"~/.zimrc\"."
