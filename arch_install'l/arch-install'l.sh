#!/bin/bash

# Colori
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
CYAN="\e[36m"
RESET="\e[0m"

set -e

# Funzione per mostrare i dischi disponibili (escludendo disco corrente)
function list_disks() {
    CURRENT_DISK=$(lsblk -no PKNAME $(findmnt -no SOURCE /))
    echo -e "${CYAN}Dischi disponibili per l'installazione (la chiavetta USB corrente: /dev/${CURRENT_DISK} è esclusa):${RESET}"
    
    mapfile -t DISKS < <(lsblk -d -o NAME,SIZE,MODEL | grep -v "$CURRENT_DISK" | grep -v loop)

    for i in "${!DISKS[@]}"; do
        # estrai nome disco, dimensione e modello
        LINE="${DISKS[$i]}"
        NAME=$(echo "$LINE" | awk '{print $1}')
        SIZE=$(echo "$LINE" | awk '{print $2}')
        MODEL=$(echo "$LINE" | cut -d' ' -f3-)
        echo -e "  ${YELLOW}[$((i+1))]${RESET} /dev/${GREEN}${NAME}${RESET} - ${SIZE} - ${MODEL}"
    done
}

# Funzione per selezionare un disco (inserendo un numero)
function select_disk() {
    if [ ${#DISKS[@]} -eq 0 ]; then
        echo -e "${RED}Nessun disco disponibile per l'installazione. Esco.${RESET}"
        exit 1
    fi

    read -rp "$(echo -e ${CYAN}Seleziona il disco da usare inserendo il numero corrispondente:${RESET} )" NUM

    if ! [[ "$NUM" =~ ^[0-9]+$ ]] || (( NUM < 1 || NUM > ${#DISKS[@]} )); then
        echo -e "${RED}Selezione non valida. Esco.${RESET}"
        exit 1
    fi

    # Recupera nome disco selezionato
    DISK_NAME=$(echo "${DISKS[$((NUM-1))]}" | awk '{print $1}')
    DISK="/dev/$DISK_NAME"

    echo -e "${GREEN}Hai selezionato il disco: $DISK${RESET}"
}

# Funzione per partizionare il disco
function partition_disk() {
    echo "⚠️ ATTENZIONE: Tutto il contenuto di $DISK sarà distrutto."
    read -rp "Confermi? (sì per continuare): " CONFIRM
    if [[ "$CONFIRM" != "sì" ]]; then
        echo "Annullato."
        exit 1
    fi

    # NUOVA CONFERMA PRIMA DI SCRIVERE LE PARTIZIONI
    echo -e "${RED}Sei sicuro di voler scrivere le partizioni sul disco $DISK? Questa operazione è irreversibile!${RESET}"
    read -rp "Scrivi 'CONFERMO' per procedere: " FINAL_CONFIRM
    if [[ "$FINAL_CONFIRM" != "CONFERMO" ]]; then
        echo "Partizionamento annullato."
        exit 1
    fi

    wipefs -a "$DISK"
    parted "$DISK" --script mklabel gpt

    echo "Crea partizioni..."
    BOOT_SIZE="512MiB"
    read -rp "Inserisci la dimensione della partizione ROOT (es: 20GiB): " ROOT_SIZE
    read -rp "Inserisci la dimensione della partizione HOME (es: 50GiB o 100% per usare tutto): " HOME_SIZE

    parted "$DISK" --script mkpart primary fat32 1MiB "$BOOT_SIZE"
    parted "$DISK" --script set 1 esp on
    parted "$DISK" --script mkpart primary ext4 "$BOOT_SIZE" "$ROOT_SIZE"
    parted "$DISK" --script mkpart primary ext4 "$ROOT_SIZE" "$HOME_SIZE"

    sleep 2
    echo "Partizioni create:"
    lsblk "$DISK"
}


# Funzione per formattare le partizioni
function format_partitions() {
    BOOT_PART="${DISK}1"
    ROOT_PART="${DISK}2"
    HOME_PART="${DISK}3"

    echo "Formatto le partizioni..."
    mkfs.fat -F32 "$BOOT_PART"
    mkfs.ext4 -F "$ROOT_PART"
    mkfs.ext4 -F "$HOME_PART"
}

# Funzione per montare le partizioni
function mount_partitions() {
    echo "Monto le partizioni..."
    mount "$ROOT_PART" /mnt
    mkdir -p /mnt/boot /mnt/home
    mount "$BOOT_PART" /mnt/boot
    mount "$HOME_PART" /mnt/home
}

# Funzione per installare Arch base + pacchetti extra
function install_base() {
    echo "Installo sistema base..."
    pacstrap /mnt base linux linux-firmware vim sudo systemd networkmanager
    genfstab -U /mnt >> /mnt/etc/fstab
}

# Funzione per configurazione interna al chroot
function configure_chroot() {
    echo "Configuro sistema dentro chroot..."

    arch-chroot /mnt /bin/bash <<EOF

# Timezone
ln -sf /usr/share/zoneinfo/Europe/Rome /etc/localtime
hwclock --systohc

# Locale
sed -i 's/#it_IT.UTF-8 UTF-8/it_IT.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=it_IT.UTF-8" > /etc/locale.conf

# Hostname
echo "archlinux" > /etc/hostname
echo "127.0.0.1   localhost" >> /etc/hosts
echo "::1         localhost" >> /etc/hosts
echo "127.0.1.1   archlinux.localdomain archlinux" >> /etc/hosts

# Abilita NetworkManager
systemctl enable NetworkManager

# Installa systemd-boot
bootctl install

# Crea loader.conf
echo "default arch" > /boot/loader/loader.conf
echo "timeout 3" >> /boot/loader/loader.conf
echo "editor no" >> /boot/loader/loader.conf

# UUID partizione ROOT
ROOT_UUID=\$(blkid -s PARTUUID -o value ${ROOT_PART})

# Crea voce boot per Arch
cat > /boot/loader/entries/arch.conf <<EOL
title   Arch Linux
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
options root=PARTUUID=\$ROOT_UUID rw
EOL

EOF
}


### --- MAIN --- ###
clear
list_disks
select_disk
partition_disk
format_partitions
mount_partitions
install_base
configure_chroot

echo ""
echo "✅ Installazione base completata!"
echo "Ora puoi entrare in chroot con: arch-chroot /mnt"
