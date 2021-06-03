## Coreboot build scripts

This is a series of scripts I use to build and flash coreboot on my machines.
For now the scripts only support x220 and x230 Thinkpads.

`build_coreboot_*` scripts will install dependencies, pull the latest coreboot git, and build it. You will need a coreboot configuration file (see below) and your machine's extracted factory ROM. ME cleaner is ran against the factory ROM. Read the script before you run it - you might need to make some modifications.

`configs/` directory contains some sample configurations. They should work out of the box, but I recommend browsing the config menu and checking the coreboot manual anyway.

`convert_embed_splash.sh` will install a bootsplash into your ROM. Read the script comments before you proceed! Imagemagick is required for this script.

`test_flash.sh` is just a convenience script which extracts the factory ROM twice and checks their hashes to ensure they're identical. It doesn't hurt to do it more than once. The script also has some examples of  chip versions. Make sure to actually check the version of the chip you are flashing - same models might have different chips!

I use the CH341A programmer, but there are many googlable alternatives.

*If you blindly run these scripts and end up bricking your machine it's on you.* It's actually pretty hard to brick, but still proceed with caution.

Please read all of the scripts before runing them and have a backup of the factory ROM just in case - good luck!
