#!/bin/bash - 

# must be run from root repo

set -e

zipfile=$1

if [[ ! -d kll ]]; then
	cd Keyboards
	./ergodox.bash || true
	echo -e '\n\n\n\n\n\n\n\'
	echo =========================================
	echo Now that "kll" was checked out, run again
	exit
fi

# XXX: kll dir is created during build
unzip -o $zipfile 'MDErgo1-Default-*' -d kll/layouts/qyron

cd Keyboards

leftdir=linux-gnu.ICED-L.gcc.make
rightdir=linux-gnu.ICED-R.gcc.make

rm -rf $leftdir $rightdir

./ergodox.bash

echo
echo
read -p "Connect LEFT keyboard and press ENTER..."
sudo dfu-util -D $leftdir/kiibohd.dfu.bin

echo
echo
read -p "Connect RIGHT keyboard and press ENTER..."
sudo dfu-util -D $rightdir/kiibohd.dfu.bin

