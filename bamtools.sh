#!/bin/bash
checkingbam()
{
  echo "Checking bamtools install"
  setupbam
  echo "Checking PATH for bamtools..."
  if find ${PATH//:/ } -maxdepth 1 -name bamtools 2> /dev/null| grep -q 'bamtools' ; then
    BAMTOOLS=$(find ${PATH//:/ } -maxdepth 1 -name bamtools 2> /dev/null | head -1)
    echo "bamtools da dat dung duong dan"
  else
    echo "bamtools dat sai duong dan " $PATH"."
    numsofts=$((numsofts + 1))
  fi
}

setupbam()
{
  #chi can dung cai nay
  sudo apt-get update
  sudo apt-get install bamtools
  
  #hoac dung cai nay
  #install jsoncpp
  #sudo apt-get install libjsoncpp-dev
  
  #if( which bamtools &>/dev/null );then
  #  echo "bamtools is already installed"
  #  else
  #    echo "Downloading bamtools..."
  #    git clone https://github.com/pezmaster31/bamtools.git
  #    cd bamtools
  #    mkdir build
  #    cd build
  #    cmake ..
  #    make
  #    cd ../bin
  #    chmod +x bamtools
  #    echo "cd .."
  #    #read answer
  #    cd ../../
  #    #mv bedtools2 bedtools
  #    #cp bedtools-2.23.0.tar.gz ../Downloads
  #fi
}
##########
numsofts=0
checkingbam
