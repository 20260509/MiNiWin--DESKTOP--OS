#!/bin/bash

cd "$(dirname "$0")/.."

pause() {
    echo ""
    echo -n "Press any key to exit..."
    read -n 1
    echo ""
}
trap pause EXIT

echo "Building MiniWin..."

nasm -f bin src/boot.asm -o bin/boot.bin || exit 1
nasm -f bin -I src/ src/kernel.asm -o bin/kernel.bin || exit 1

dd if=/dev/zero of=bin/os.img bs=512 count=2880 2>/dev/null || exit 1
dd if=bin/boot.bin of=bin/os.img bs=512 count=1 conv=notrunc 2>/dev/null || exit 1
dd if=bin/kernel.bin of=bin/os.img bs=512 seek=1 conv=notrunc 2>/dev/null || exit 1

echo ""
echo "✅ BUILD OK"
echo "▶️  Run: qemu-system-x86_64 -drive format=raw,file=bin/os.img"
echo ""
echo -n "Run QEMU now? (y/n): "
read -n 1 answer
echo ""

if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
    echo "Starting QEMU..."
    qemu-system-x86_64 -drive format=raw,file=bin/os.img
else
    echo "Exiting."
    exit 0
fi