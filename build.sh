#!/bin/bash
# build.sh - Script untuk mengkompilasi OS di lingkungan Linux/WSL

# Pastikan i686-elf-gcc (cross-compiler) terpasang.
# Jika Anda menggunakan Linux biasa, terkadang 'gcc' dan 'as' standar dengan flag -m32 bisa berjalan, 
# tetapi menggunakan cross-compiler sangat direkomendasikan.

echo "Membangun IMPHEN-OS..."

# 1. Compile Assembly Bootloader
as --32 boot.s -o boot.o

# 2. Compile Kernel C
gcc -m32 -c kernel.c -o kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra

# 3. Link file menjadi binary OS
gcc -m32 -T linker.ld -o imphen-os.bin -ffreestanding -O2 -nostdlib boot.o kernel.o -lgcc

# 4. Verifikasi Multiboot
if grub-file --is-x86-multiboot imphen-os.bin; then
  echo "Multiboot terkonfirmasi! File siap di-booting."
else
  echo "Error: File tidak dikenali sebagai Multiboot."
fi

# 5. Jalankan di QEMU (Jika ada)
qemu-system-i386 -kernel imphen-os.bin
