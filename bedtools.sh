#!/bin/bash
checkingbed()
{
  echo "Checking bedtools install"
  setupbed
  echo "Checking PATH for bedtools..."
  if find ${PATH//:/ } -maxdepth 1 -name bedtools 2> /dev/null| grep -q 'bedtools' ; then
    BEDTOOLS=$(find ${PATH//:/ } -maxdepth 1 -name bedtools 2> /dev/null | head -1)
    echo "bedtools da dat dung duong dan"
  else
    echo "bedtools dat sai duong dan " $PATH"."
    numsofts=$((numsofts + 1))
  fi
}

setupbed()
{
  echo "checking python"
  if( find python &>/dev/null );then
    echo "python is already installed"
    else
      echo "install python first"
      sudo apt-get install python
  fi  
  if( which bedtools &>/dev/null );then
    echo "bedtools is already installed"
    else
      echo "Downloading bedtools..."
      curl -L -O https://github.com/arq5x/bedtools2/releases/download/v2.23.0/bedtools-2.23.0.tar.gz
      tar xvzf bedtools-2.23.0.tar.gz
      cd bedtools2
      make 
      cd bin
      chmod +x *
      echo "cd .."
      #read answer
      cd ..
      mv bedtools2 bedtools
      mv bedtools-2.23.0.tar.gz ../Downloads
  fi
}
##########
numsofts=0
checkingbed
