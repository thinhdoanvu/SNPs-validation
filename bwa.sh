#!/bin/bash
checkingbwa()
{
  echo "Checking bwa install"
  setupbwa
  echo "Checking PATH for bwa..."
  if find ${PATH//:/ } -maxdepth 1 -name bwa 2> /dev/null| grep -q 'bwa' ; then
    BWA=$(find ${PATH//:/ } -maxdepth 1 -name bwa 2> /dev/null | head -1)
    echo "bwa da dat dung duong dan"
  else
    echo "bwa dat sai duong dan " $PATH"."
    numsofts=$((numsofts + 1))
  fi
}

setupbwa()
{
  if( find bwa &>/dev/null );then
    echo "bwa is already installed"
    else
      echo "Downloading bwa..."
      echo "git clone https://github.com/lh3/bwa.git"
      #read answer
      git clone https://github.com/lh3/bwa.git
      cd bwa
      make
      chmod +x bwa
      echo "cd .."
      #read answer
      cd ..
      cp bwa ../Downloads
  fi
}
##########
numsofts=0
checkingbwa
