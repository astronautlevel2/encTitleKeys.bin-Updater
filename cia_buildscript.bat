3dstool -cvtf romfs romfs.bin --romfs-dir romfs
makerom -f cia -o lpp-3ds.cia -elf lpp-3ds.elf -rsf cia_workaround.rsf -icon icon.bin -banner banner.bin -exefslogo -target t -romfs romfs.bin