#!/bin/bash
checkingstacks()
{
  echo "Checking stacks install"
  setupstacks
  echo "Checking PATH for stacks..."
  if find ${PATH//:/ } -maxdepth 1 -name stacks 2> /dev/null| grep -q 'stacks' ; then
    STACKS=$(find ${PATH//:/ } -maxdepth 1 -name stacks 2> /dev/null | head -1)
    echo "stacks da dat dung duong dan"
  else
    echo "stacks dat sai duong dan " $PATH"."
    numsofts=$((numsofts + 1))
  fi
}

setupstacks()
{
  if( find stacks &>/dev/null );then
    echo "stacks is already installed"
    else
      echo "Downloading stacks..."
      curl -L -o stacks-1.35.tar.gz "http://catchenlab.life.illinois.edu/stacks/source/stacks-1.35.tar.gz"	
      tar -zxvf stacks-1.35.tar.gz
      cd stacks-1.35
      ./configure
      make
      cd ../
      mv stacks-1.35 stacks 
      mv stacks-1.35.tar.gz ../Downloads/
  fi
}
##########
numsofts=0
checkingstacks
