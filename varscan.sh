#!/bin/bash
checkingvscan()
{
  echo "Checking varscan install"
  setupvscan
  echo "Checking PATH for varscan..."
  if find ${PATH//:/ } -maxdepth 1 -name varscan.jar 2> /dev/null| grep -q 'varscan' ; then
    VARSCAN=$(find ${PATH//:/ } -maxdepth 1 -name varscan.jar 2> /dev/null | head -1)
    echo "varscan da dat dung duong dan"
  else
    echo "varscan dat sai duong dan " $PATH"."
    numsofts=$((numsofts + 1))
  fi
}

setupvscan()
{
  if( find varscan.jar &>/dev/null );then
    echo "VarScan is already installed"
    else
      echo "Downloading VarScan..."
      curl -L -o VarScan.v2.3.7.jar "http://sourceforge.net/projects/varscan/files/VarScan.v2.3.7.jar/download"	
      mv VarScan.v2.3.7.jar varscan.jar
      chmod 755 varscan
      #echo "cd .."
      #read answer
     #cp varscan ../Downloads
  fi
}
##########
numsofts=0
checkingvscan
