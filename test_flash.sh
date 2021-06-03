#!/bin/bash
set -e

TESTNAME="test"

# Set these variables accordingly. Below are some examples.
# Chip versions can vary even on the same model, so get your magnifying glass out. 

CHIP=
PROGRAMMER=

# CHIP="W25Q64.V" #x220
# CHIP="MX25L6436E/MX25L6445E/MX25L6465E/MX25L6473E/MX25L6473F" # x220
# CHIP="MX25L3206E/MX25L3208E" # x230 top chip
# CHIP="MX25L6406E/MX25L6408E" # x230 bottom chip

# PROGRAMMER="ch341a_spi"

if [[ -z $CHIP || -z $PROGRAMMER ]]
then
	echo "[!!] Did you read the script? A variable is unset"
	exit 1
fi

sudo flashrom --programmer "$PROGRAMMER" -r "${TESTNAME}0.bin" -c "$CHIP"
sudo flashrom --programmer "$PROGRAMMER" -r "${TESTNAME}1.bin" -c "$CHIP"

diff "${TESTNAME}0.bin" "${TESTNAME}1.bin"

if [[ $? -ne 0 ]]
then
	echo "[!!] Do not proceed. There might have been an issue with reading the flash."
	echo "[!!] Check the programmer and the clip and try again."
	exit 1
else
	echo "[*] Two flash reads yielded identical results."
	exit 0
fi
