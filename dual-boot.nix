{ ... }:

{
    boot.loader.grub.useOSProber = true; # Automatically detects other OS's
    boot.loader.grub.extraEntries = ''
        menuentry "Arch Linux" {
          insmod part_gpt
          insmod fat
          insmod ext2
          set root=(hd0,gpt5)
          linux /vmlinuz-linux root=/dev/nvme0n1p6 rw loglevel=4
          initrd /initramfs-linux.img
        }
    '';
}
