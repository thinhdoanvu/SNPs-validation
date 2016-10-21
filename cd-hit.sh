#!/bin/bash
checkingcdhit()
{
  echo "Checking cd-hit-est install"
  setupcdhit
  echo "Checking PATH for cd-hit-est..."
  if find ${PATH//:/ } -maxdepth 1 -name cd-hit-est 2> /dev/null| grep -q 'cd-hit-est' ; then
    CDHIT=$(find ${PATH//:/ } -maxdepth 1 -name cd-hit-est 2> /dev/null | head -1)
    echo "cd-hit-est da dat dung duong dan"
  else
    echo "cd-hit-est dat sai duong dan " $PATH"."
    numsofts=$((numsofts + 1))
  fi
}

setupcdhit()
{
  if( find cd-hit-est &>/dev/null );then
    echo "cd-hit-est is already installed"
    else
      echo "Downloading cd-hit-est..."
      curl -L -O https://cdhit.googlecode.com/files/cd-hit-v4.6.1-2012-08-27.tgz
      tar xvzf cd-hit-v4.6.1-2012-08-27.tgz 
      cd cd-hit-v4.6.1-2012-08-27
      make openmp=yes
      chmod +x cd-hit-est cd-hit-est-2d
      echo "cd .."
      #read answer
      cd ..
      mv  cd-hit-v4.6.1-2012-08-27 cd-hit
      mv cd-hit-v4.6.1-2012-08-27.tgz ../Downloads
  fi
}
##########
numsofts=0
checkingcdhit
