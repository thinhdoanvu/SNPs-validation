#!/bin/bash
numerr=0
echo "Checking CPU..."
cpu_num=$(grep -c ^processor /proc/cpuinfo 2> /dev/null)
cpu_num=$((cpu_num+0))
cpu_model=$(grep "model name" /proc/cpuinfo 2> /dev/null| uniq)
echo -e "Tong so Cores: "$cpu_num
echo $cpu_model
#echo "Nhap so Cores toi da duoc phep su dung:"
#read cores
#while [[ $cores -lt 1  ||  $cores -gt $cpu_num ]]; do
#  echo "So Cores CPU <= "$cpu_num" va >= 1"
#  read cores
#done

echo "Checking RAM..."
maxmem=$(($(grep -Po '(?<=^MemTotal:)\s*[0-9]+' /proc/meminfo | tr -d " ") / 1000000))
echo "Memory total: "$maxmem"G"
freemem=$(($(grep -Po '(?<=^MemFree:)\s*[0-9]+' /proc/meminfo | tr -d " ") / 1048576))
echo "Free memory: "$freemem"G"
#echo "Nhap so RAM  toi da duoc phep su dung:"
#read mem
#while [[ $mem -lt 1  ||  $mem -gt $freemem ]]; do
#  echo "Dung luong RAM <= "$freemem" va >= 1G"
#  read mem
#done

echo "Checking HDD..."
lsblk

echo "Checking folder programs..."
path=(`pwd | grep -c "programs"`)
if(( $path \> 0 )); then
  echo "copy file all files to programs folder"
  echo "press Enter to quit"
  read answer
  else
    echo "mkdir programs"
    mkdir programs
    cd programs
    echo "copy all file .sh to here"
    read answer
    exit
fi

echo "Seting up some requires..."
if ( which make &>/dev/null ) ; then
  echo "make is already installed"
  else
    numerr=$((numerr+1))
    echo "sudo apt-get install make"
    echo "press Enter key"
    read answer
    sudo apt-get install make
fi

if ( which tmux &>/dev/null ) ; then
  echo "tmux is already installed"
  else
    numerr=$((numerr+1))
    echo "type: sudo apt-get install tmux"
    echo "press Enter key"
    read answer
    sudo apt-get install tmux
fi

if( which g++ &>/dev/null ); then
  echo "g++ is already installed"
  else
    numerr=$((numerr+1))
    echo "sudo apt-get install g++"
    echo "press Enter key"
    read answer
    sudo apt-get install g++
fi

if( which git &>/dev/null );then
  echo "git is already installed"
  else
    numerr=$((numerr+1))
    echo "sudo apt-get install git"
    echo "press Enter key"
    read answer
    sudo apt-get install git
fi

if ( which curl &>/dev/null );then
  echo "curl is already installed"
  else
    numerr=$((numerr+1))
    echo "sudo apt-get install curl"
    echo "press Enter key"
    read answer
    sudo apt-get install curl
fi

if( which clang &>/dev/null );then
  echo "clang is already installed"
  else
    numerr=$((numerr+1))
    echo "sudo apt-get install clang"
    echo "press Enter key"
    read answer
    sudo apt-get install clang
fi

if ( which gunzip &>/dev/null ); then
  echo "gunzip is already installed"
  else
    numerr=$((numerr+1))
    echo "sudo apt-get install gunzip"
    echo "press Enter key"
    read answer
    sudo apt-get install gunzip
fi

if( which gsl-config &>/dev/null );then
  echo "libgsl0-dev is already installed"
  else
    numerr=$((numerr+1))
    echo "sudo apt-get install libgsl0-dev"
    echo "press Enter key"
    read answer
    sudo apt-get install libgsl0-dev
fi

if( find /usr/include/gsm.h &>/dev/null );then
  echo "libgsm1-dev is already installed"
  else
    numerr=$((numerr+1))
    echo "sudo apt-get install libgsm1-dev"
    echo "press Enter key"
    read answer
    sudo apt-get install libgsm1-dev
fi

if( find /usr/include/curses.h &>/dev/null );then
  echo "libncurses5-dev is already installed"
  else
    numerr=$((numerr+1))
    echo "sudo apt-get install libncurses5-dev"
    echo "press Enter key"
    read answer
    sudo apt-get install libncurses5-dev
fi

if( find /usr/include/ncursesw/curses.h &>/dev/null );then
  echo "libncursesw5-dev is already installed"
  else
    numerr=$((numerr+1))
    echo "sudo apt-get install libncursesw5-dev"
    echo "press Enter key"
    read answer
    sudo apt-get install libncursesw5-dev
fi

if ( find /usr/share/build-essential &>/dev/null ); then
  echo "build-essential is already installed"
  else
    numerr=$((numerr+1))
    echo "sudo apt-get install build-essential"
    echo "press Enter key"
    read answer
    sudo apt-get install build-essential
fi

if( which java &>/dev/null );then
  echo "java is already installed"
  else
    numerr=$((numerr+1))
    echo "sudo apt-get install default-jre"
    echo "press Enter key"
    read answer
    sudo apt-get install default-jre
fi

if( find /usr/include/zlib.h &>/dev/null );then
  echo "zlib1g-dev is already installed"
  else
    numerr=$((numerr+1))
    echo "sudo apt-get install zlib1g-dev"
    echo "press Enter key"
    read answer
    sudo apt-get install zlib1g-dev
fi

if (( $numerr \> 0 ));then
  echo "Co "$numerr" phan mem chua duoc cai dat ..."
  else
  echo "ALL basic libs is OK...Press ENTER to NEXT..."
  read answer
fi
#####

