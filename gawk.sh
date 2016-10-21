#!/bin/bash
checkingbed()
{
  echo "Checking gawk install"
  setupbed
  echo "Checking PATH for gawk..."
  if find ${PATH//:/ } -maxdepth 1 -name gawk 2> /dev/null| grep -q 'gawk' ; then
    GAWK=$(find ${PATH//:/ } -maxdepth 1 -name gawk 2> /dev/null | head -1)
    echo "gawk da dat dung duong dan"
  else
    echo "gawk dat sai duong dan " $PATH"."
    numsofts=$((numsofts + 1))
  fi
}

setupgawk()
{
  if( find gawk &>/dev/null );then
    echo "gawk is already installed"
    else
      sudo apt-get install devscripts build-essential
      sudo apt-get build-dep gawk
      sudo apt-get install gawk
      sudo apt-get install gnome-doc-utils
      #read answer
  fi
}
##########
numsofts=0
checkingbed
