#!/bin/bash
checkingmawk()
{
  echo "Checking trimommatic install"
  setupmawk
  echo "Checking PATH for trimmomatic..."
  if find ${PATH//:/ } -maxdepth 1 -name mawk 2> /dev/null| grep -q 'mawk' ; then
    MAWK=$(find ${PATH//:/ } -maxdepth 1 -name mawk 2> /dev/null | head -1)
    echo "mawk da dat dung duong dan"
  else
    echo "mawk dat sai duong dan " $PATH"."
    numsofts=$((numsofts + 1))
  fi
}

setupmawk()
{
  if( find mawk &>/dev/null );then
    echo "mawk is already installed"
    else
      echo "Downloading mawk..."
      echo "curl -O http://invisible-island.net/datafiles/release/mawk.tar.gz"
      #read answer
      curl -O http://invisible-island.net/datafiles/release/mawk.tar.gz
      tar xvzf mawk.tar.gz
      cd mawk-1.*
      ./configure
      make
      chmod +x mawk
      echo "cd .."
      #read answer
      mv mawk-1.3.4-20150503 mawk
      cd ..
      mv mawk*gz ../Downloads
  fi
}
##########
numsofts=0
checkingmawk
