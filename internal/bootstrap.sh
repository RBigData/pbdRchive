#!/bin/sh

NCORES=2
export PBDHOME=/home/pbdRchive # FIXME?

#----------------------------------------------------------------
# This script will bootstrap a pbdRchive environment on a new
# Ubuntu VM.
#----------------------------------------------------------------

### Directory structure
# pbdRchive
#          ├── bin
#          ├── bootstrap
#          ├── dev
#          ├── docs
#          └── website

### Paths and shit, whatevs it's cool
cd ${PBDHOME}
mkdir boodstrap dev docs

export MAKE="/usr/bin/make -j $(( $NCORES+1 ))"
CODENAME=`lsb_release -c | sed -e "s/Codename:\t//"`

if [ ! -a ~/.inputrc ]; then 
  echo "\$include /etc/inputrc" > ~/.inputrc
fi
echo "set completion-ignore-case On" >> ~/.inputrc

export PATH=${PBDHOME}/bin:${PATH}


### Add swap
sudo dd if=/dev/zero of=/swap bs=1M count=1024
sudo mkswap /swap
sudo swapon /swap
sudo cat "/swap swap swap defaults 0 0" >> /etc/fstab

### Bare necessities
sudo add-apt-repository ppa:chris-lea/libsodium -y
sudo apt-get -qq update 
sudo apt-get -qq upgrade
sudo apt-get install vim git tmux \ 
  build-essential libclang-dev clang gfortran \
  libcurl4-openssl-dev libzmq3-dev libsodium-dev \
  openmpi-bin libopenmpi-dev libnetcdf-dev \
  libopenblas-dev libatlas-dev aspell libaspell-dev
  

### Set up R
sudo cat "deb http://cran.rstudio.com/bin/linux/ubuntu $CODENAME/" >> /etc/apt/sources.list
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
sudo apt-get -qq update
sudo apt-get install -qq r-base-dev


### Get all RBigData packages from gh
user=RBigData
names=`curl -s https://api.github.com/users/${user}/repos | grep full_name | sed -e 's/.*: "\(.*\)",/\1/' -e "s/$user\///g"`

cd ${PBDHOME}/dev

for repo in ${names};do
  cd ${PBDHOME}/dev
  if [ -d "$repo" ]; then
    cd $repo && git pull
  else
    git clone "https://github.com/$user/$repo" "$repo"
  fi
done


cd ${PBDHOME}/dev
mv RBigData.github.io/ ${PBDHOME}/website/
mv installation-instructions/ pbd-tutorial/ TODO/ ${PBDHOME}/docs

### TODO fill docs/pbdPKG with vignette and package docs

### TODO run buildrd
