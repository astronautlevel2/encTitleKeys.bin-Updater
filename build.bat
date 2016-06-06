bannertool makebanner -i "assets/banner.png" -a "assets/audio.wav" -o "banner.bin"
bannertool makesmdh -i "assets/icon.png" -s "encTitleKeysUpdater" -l "encTitleKeysUpdater for freeShop" -p "MatMaf" -o "icon.bin"
3dstool -cvtf romfs romfs.bin --romfs-dir script
makerom -f cia -o "encTitleKeysUpdater v.cia" -elf "lpp-3ds.elf" -rsf "cia_workaround.rsf" -icon "icon.bin" -banner "banner.bin" -exefslogo -target t -romfs "romfs.bin"