#!/bin/bash
checkfreeb()
{
  echo "Checking freebayes install"
  checkfreeb
#kiem tra tuong thich phan mem
  echo "Checking PATH for freebayes..."
  if find ${PATH//:/ } -maxdepth 1 -name freebayes 2> /dev/null ; then
    FREEBAYES=$(find ${PATH//:/ } -maxdepth 1 -name freebayes 2> /dev/null | head -1)
    echo "freebayes da dat dung duong dan"
  else
    echo "freebayes dat sai duong dan " $PATH"."
    numsofts=$((numsofts + 1))
  fi
  FREEB=(`freebayes | grep -oh 'v[0-9].*' | sed 's/-.*//g' `)	
  if [ "$FREEB" != "v0.9.21" ]; then
    echo "Phien ban freebayes hien co trong" '$PATH' "khong tuong thich."
    echo "Cai dat freebayes version 0.9.21"
  fi         	
}

setupfree()
{
  if ( find freebayes &>/dev/null ) ; then 
    echo "freebayes is already installed"
    else
      echo "Downloading and installing freebayes"
      git clone --recursive https://github.com/ekg/freebayes.git
      cd freebayes
      make
      cd bin
      chmod +x *
      cd ..
      cd vcflib
      make
      chmod +x ./bin/*
      cd ../../
  fi
}
##########
numsofts=0
checkfreeb
