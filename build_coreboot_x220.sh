#!/bin/bash
set -e

if [[ $# -ne 2 ]]
then
    echo "$0 <coreboot_config> <original BIOS rom>"
    exit 1
fi

MACHINE="i386"
CORECONFIG="$1"
OG_BIOS="$2"

# If you have a different package manager change appropriately
sudo pacman -S base-devel curl git gcc-ada ncurses zlib flashrom

git clone https://review.coreboot.org/coreboot
cd coreboot
git submodule update --init --checkout

make "crossgcc-$MACHINE" CPUS=$(nproc)
make iasl

cd util/ifdtool
echo "[!] Building and installing ifdtool"
sudo make install

cd ../me_cleaner
echo "[!] Installing ME cleaner"
sudo python setup.py install

cd ../cbfstool
echo "[!] Installing cbfstool"
sudo make

cd ../../../

ifdtool -x "$OG_BIOS"

BOARD_DIR="coreboot/3rdparty/blobs/mainboard/lenovo/x220"
mkdir -p "$BOARD_DIR"

mv flashregion_0_flashdescriptor.bin "$BOARD_DIR/descriptor.bin"
mv flashregion_2_intel_me.bin "$BOARD_DIR/me.bin"
mv flashregion_3_gbe.bin "$BOARD_DIR/gbe.bin"

cp $CORECONFIG coreboot/.config
cd coreboot
make olddefconfig
make

echo "[*] ROM image: coreboot/build/coreboot.rom"
echo "[*] To flash [did you back up the factory ROM? Do it now if you haven't]:"
echo "[*] $ sudo flashrom --programmer <programmer> -w corebot.rom -c <chip_version>"
echo "[*] Make sure to run test_flash.sh before proceeding"


