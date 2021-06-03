#!/bin/bash

# I found this method of adding a bootsplash to be the most reliable.
# For this to work you must build coreboot with all of the bootsplash
# options disabled.

usage() {
	echo "$0 <path_to_coreboot_root> <path_to_bootsplash_img>"
	exit 1
}

set -e

CBFPATH="$1/util/cbfstool/cbfstool"
ROMPATH="$1/build/coreboot.rom"
BOOTSPLASH="bootsplash_$(date +%s).bmp"

if [[ $# -ne 2 ]]
then
	usage "$0"
fi

echo "[!!] Check the following:"
echo -e "[!!]\t- $2 has exactly 1366:768 dimensions"
echo -e "[!!]\t- $ROMPATH is built with bootsplash options disabled"
echo -e "[!!]\t- If you need to split the ROM to flash it, make sure to run"
echo -e "[!!]\t  this script before you split it"

echo "[!!] [Enter] to continue, [Ctrl+C] to quit"

read a

echo "[*] Converting the bootsplash image... "
convert "$2" -alpha set -verbose -depth 32 "$BOOTSPLASH"

echo "[*] Adding the bootsplash to the rom... "
"$CBFPATH" "$ROMPATH" add -f "$BOOTSPLASH" -c lzma -n bootsplash.bmp.lzma -t raw

echo "[*] Bootsplash added to $ROMPATH. Converted bootsplash backup saved to $BOOTSPLASH"

