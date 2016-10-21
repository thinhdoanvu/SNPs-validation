#!/bin/bash
checkingcmake()
{
  echo "Checking cmake install"
  setupcmake
  echo "Checking PATH for cmake..."
  if find ${PATH//:/ } -maxdepth 1 -name cmake 2> /dev/null ; then
    CMAKE=$(find ${PATH//:/ } -maxdepth 1 -name cmake 2> /dev/null | head -1)
    echo "cmake da dat dung duong dan"
  else
    echo "cmake dat sai duong dan " $PATH"."
    numsofts=$((numsofts + 1))
  fi
}

setupcmake()
{
  if ( find cmake &>/dev/null ) ; then 
    echo "cmake is already installed"
    else
      echo "Downloading and installing cmake"
      curl -O https://cmake.org/files/v3.4/cmake-3.4.0-rc3.tar.gz
      tar xvzf cmake-3.4.0-rc3.tar.gz
      cd cmake-3.4.0-rc3
      ./configure
      make
      sudo make install
      cd ..
      mv cmake-3.4.0-rc3 cmake
      mv cmake-3.4.0-rc3.tar.gz ../Downloads
  fi
}
##########
numsofts=0
checkingcmake
