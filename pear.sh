#!/bin/bash
checkingpear()
{
  echo "Checking pear install"
  setuppear
  echo "Checking PATH for pear..."
  if find ${PATH//:/ } -maxdepth 1 -name pear 2> /dev/null| grep -q 'pear' ; then
    PEAR=$(find ${PATH//:/ } -maxdepth 1 -name pear 2> /dev/null | head -1)
    echo "pear da dat dung duong dan"
  else
    echo "pear dat sai duong dan " $PATH"."
    numsofts=$((numsofts + 1))
  fi
}

setuppear()
{
  if( find pear &>/dev/null );then
    echo "pear is already installed"
    else
      echo "Downloading pear..."
      curl -L -O http://sco.h-its.org/exelixis/web/software/pear/files/pear-0.9.6-bin-64.tar.gz
      tar vxzf pear-0.9.6-bin-64.tar.gz 
      cd pear-0.9.6-bin-64
      cp -f pear-0.9.6-bin-64 pearRM
      chmod +x pearRM
      echo "cd .."
      #read answer
      cd ../
      mv pear-0.9.6-bin-64 pear
      mv pear-0.9.6-bin-64.tar.gz ../Downloads
  fi
}
##########
numsofts=0
checkingpear
