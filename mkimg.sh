#!/bin/bash
size=128M
img="steckos.img"
TARGET=::/

version=$(git rev-parse --short HEAD)

if [ -e ${img} ] ; then
  rm ${img}
fi

truncate -s $size ${img}
mkfs -t fat -F 32 -s 2  ${img} -n ${version^^}

mmd -i ${img} ::/steckos ../progs # ::/demo ::/games ::/progs ::/basic ::/basic/benchmrk

mcopy -i ${img}  steckos/tools/*.prg $TARGET/steckos/
# mcopy -i ${img}  steckos/demo/*.prg $TARGET/demo/
# mcopy -i ${img}  steckos/demo/plasma/*.prg $TARGET/demo/
# mcopy -i ${img}  steckos/demo/qrcode/*.prg $TARGET/demo/
# mcopy -i ${img}  steckos/demo/*.ppm $TARGET/demo/

# GAMES="games/dinosaur/dinosaur.prg games/pong/pong.prg games/microchess/mchess.prg games/shmup/shmup.prg games/pacman/pacman.prg"
# mcopy -i ${img} $GAMES $TARGET/games/

#PROGS=$(find progs -name "*.prg")
#mcopy -i ${img} $PROGS $TARGET/progs/

# mcopy -i ${img} progs/ehbasic_65c02/demo/* $TARGET/basic
# mcopy -i ${img} progs/ehbasic_65c02/benchmark/* $TARGET/basic/benchmrk

if [ -d "../local" ] ; then
	mcopy -snvom -i ${img} ../local/* $TARGET/
fi
