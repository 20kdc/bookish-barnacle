#!/bin/sh
# No Windows version, sorry, but that said, you can get a Windows FFMPEG from
#  https://ffmpeg.org/download.html
# You should be able to follow along from there, as I put all the difficult stuff into to1bit
# This doesn't make fps.txt though
rm -rf to1bit/frames
mkdir -p to1bit/frames
ffmpeg -i videos/$1/input -s 80x60 to1bit/frames/%d.png
ffmpeg -i videos/$1/input -vn videos/$1/music.ogg
love to1bit
# note: if converting to a Windows batch file
# this will PROBABLY ACT UP b/c it won't wait for love2d to stop
rm -rf to1bit/frames
mv to1bit/tmp.bin videos/$1/video.bin

