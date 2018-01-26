## Liste des commandes pour installer Arch Linux (Janvier 2018):

#### 1: Passer le clavier en français:
- loadkeys fr-pc (loqdkeys fr)pc en Qwerty)

#### 2: Vérification de la connexion au réseau:
- ip address show

#### 3: Passer l'horloge de la machine à l'heure française:
- timedatectl set-timezone Europe/Paris

#### 4: Partionnement et formatage du disque:
###### 4.1: Partionnement
- cfdisk (puis sélectionner GPT pour une installe avec UEFI)
	* /dev/sda1 - 550Mo - EFI System
	* /dev/sda2 - 10G - Linux root (x86_64): peut être plus grande si besoin
	* /dev/sda3 - 4G - Linux Swap: en fonction de la quantité de RAM
	* /dev/sda4 - le reste du disque - Linux home

###### 4.2: Formatage et montage
- mkfs
	* mkfs.vfat -F32 /dev/sda1 (efi)
	* mkfs.ext4 /dev/sda2
	* mkswap /dev/sda3 (swap)
	* mkfs.ext4 /dev/sda4
- mount
	* mount /dev/sda2 /mnt (root)
	* mkdir /mnt/home && mount /dev/sda4 /mnt/home (home)
	* swapon /dev/sda3 (swap)
	* mkdir -p /mnt/boot/efi && mount -t vfat /dev/sda1 /mnt/boot/efi (efi)

#### 5: Installation du système de base
###### 5.1: Mise à jour des dépôts
- mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.orig
- rankmirrors -n 6 /etc/pacman.d/mirrorlist.orig >/etc/pacman.d/mirrorlist
- pacman -Syy

###### 5.2 Système de base
- pacstrap /mnt base base-devel

#### 6: Configuration de l'installation
###### 6.1: Ftstab
- genfstab -U -p /mnt >> /mnt/etc/fstab

###### 6.2: Nom de la machine
- arch-chroot /mnt
- echo NomDeLaMachine > /etc/hostname
- echo '127.0.1.1 NomDeLaMachine.localdomain NomDeLaMachine' >> /etc/hosts

###### 6.3: Heure locale (si pas fait au début)
- ln -s /usr/share/zoneinfo/Europe/Paris /etc/localtime

###### 6.4: Modification de la langue du système et de la configuration du clavier
- nano /etc/locale.gen (décommenter la locale)
- locale-gen
- echo LANG="fr_FR.UTF-8" > /etc/locale.conf
- export LANG=fr_FR.UTF-8
- echo KEYMAP=fr > /etc/vconsole.conf

###### 6.5: RAMdisk
- mkinitcpio -p linux

###### 6.6: Modification du mot de passe de root
- passwd

#### 7: Installation d'un booloader en UEFI (Grub)
###### 7.1: Téléchargement et installation
- pacman -S grub
- mount -t vfat /dev/sda1 /boot/efi
- mkdir -p /boot/efi/EFI
- grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=arch_grub --recheck

###### 7.2: OS-prober au cas où plusieurs OS d'installés
- pacman -S os-prober
- os-prober

###### 7.3: Généer le fichier de configuration
- grub-mkconfig -o /boot/grub/grub.cfg

#### 8: Après l'installation:
###### 8.1: Ajouter un utilisateur
- useradd -g users -G groupe1,groupe2 -m "nom utilisateur" (le groupe wheel est pour les utilisateurs administrateurs)
- passwd "nom utilisateur"
- "nom utilisateur" ALL=(ALL) ALL dans le fichier des sudoers (doit être fait avec le compte root)

###### 8.2: Utilitaire pour bash
- pacman -S bash-completion

###### 8.3: Environnement de bureau
- pacman -Syu xorg-server xorg-xinit
- pacman -S xfce4 xfce4-goodies
- nano ~/.xinitrc (ajouter exec xfc4)

###### 8.4: Gestionnaire de connexion
- pacman -S sddm
- systemctl enable sddm.service
- systemctl start sddm.service

###### 8.5: Fonts
- pacman -S xorg-fonts-type1 ttf-dejavu artwiz-fonts font-bh-ttf font-bitstream-speedo gsfonts sdl_ttf ttf-bitstream-vera ttf-cheapskate ttf-liberation ttf-freefont ttf-arphic-uming ttf-baekmuk

#### 9: Problème de connexion à internet
Si il y a des problèmes de connexion à internet pendant l'installation ou après le redémarrage, lancer les commandes suivantes:
- ip link set "nom interface" up
- systemctl enable dhcpcd.service
- systemctl start dhcpcd.service
