#!/bin/bash - 

# must be run from root repo

set -e

zipfile=$1

cd Keyboards
[[ -d .venv ]] || PIPENV_VENV_IN_PROJECT=1 pipenv install
venv_dir="$(pipenv --venv)"
source $venv_dir/bin/activate
export PYTHONDONTWRITEBYTECODE=1
export PIPENV_ACTIVE=1

# if [[ ! -d ../kll ]]; then
# 	./ergodox.bash || true
# 	echo -e '\n\n\n\n\n\n\n\'
# 	echo =========================================
# 	echo Now that "kll" was checked out, run again
# 	exit
# fi

# XXX: kll dir is created during build
layouts_dir=($venv_dir/lib/python*/site-packages/kll/layouts)
unzip -o $zipfile 'MDErgo1-Default-*' -d ${layouts_dir[0]}/qyron

leftdir=linux-gnu.ICED-L.gcc.ninja
rightdir=linux-gnu.ICED-R.gcc.ninja

rm -rf $leftdir $rightdir

./ergodox.bash

if [[ -z "$right" ]]; then
	echo
	echo
	read -p "Connect LEFT keyboard and press ENTER..."
	sudo dfu-util -D $leftdir/kiibohd.dfu.bin
fi

echo
echo
read -p "Connect RIGHT keyboard and press ENTER..."
sudo dfu-util -D $rightdir/kiibohd.dfu.bin

