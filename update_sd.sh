#!/bin/bash
echo "Preparing device for sdcard image"
sudo losetup /dev/loop0 sdcard.img
sudo partprobe /dev/loop0
echo "Mounting sdcard image"
mkdir sd
sudo mount -o uid=1000 /dev/loop0p1 sd
echo "Copying files..."
echo "COMLOG.PRG"
cp COMLOG.PRG sd
echo "HISTBG.BIN"
cp HISTBG.BIN sd
echo "PARTFONT.BIN"
cp PARTFONT.BIN sd
echo "ZSBG.BIN"
cp ZSBG.BIN sd
echo "HISTMUSIC.ZSM"
cp HISTMUSIC.ZSM sd
echo "GAMEMUSIC.ZSM"
cp GAMEMUSIC.ZSM sd
echo "Unmounting sdcard image"
sudo umount sd
echo "Deleting device for sdcard image"
rm -r sd
sudo losetup -d /dev/loop0
