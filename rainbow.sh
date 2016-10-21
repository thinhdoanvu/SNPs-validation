#!/bin/bash
checkingrainbow()
{
  echo "Checking rainbow install"
  setuprainbow
  echo "Checking PATH for rainbow..."
  if find ${PATH//:/ } -maxdepth 1 -name rainbow 2> /dev/null| grep -q 'rainbow' ; then
    RAIN=$(find ${PATH//:/ } -maxdepth 1 -name rbasm 2> /dev/null | head -1)
    echo "rainbow is right PATH"
  else
    echo "rainbow is wrong " $PATH"."
    numsofts=$((numsofts + 1))
  fi
}

setuprainbow()
{
  if( find rainbow &>/dev/null );then
    echo "rainbow is already installed"
    echo "checking newest version..."
    VER=(`rainbow | head -1 | cut -f2 -d' ' `)
    if [[ "$VER" == "2.0.4" ]];then
      echo "rainbow newest version..."
      else
      echo "Need to install newset version..."
    fi
    else
      echo "Downloading rainbow for assembly..."
      echo "curl -O http://sourceforge.net/projects/bio-rainbow/files/rainbow_2.0.4.tar.gz/download"
      #read answer
      curl -L -o rainbow_2.0.4.tar.gz http://sourceforge.net/projects/bio-rainbow/files/latest/download?source=files
      tar -zxvf rainbow_2.0.4.tar.gz
      echo "cd rainbow_2.0.4"
      mv rainbow_2.0.4 rainbow
      cd rainbow
      #read answer
      echo "make"
      make
      echo "sudo make install"
      sudo make install
      chmod 755 rainbow rbasm tags select_*
      cd ../
      echo "moving file to Downloads folder"
      mv rainbow_2.0.4.tar.gz ../Downloads
  fi
}
##########
numsofts=0
checkingrainbow
