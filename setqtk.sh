#!/bin/bash
checkingsetq()
{
  echo "Checking seqtk install"
  setupsetq
  echo "Checking PATH for seqtk..."
  if find ${PATH//:/ } -maxdepth 1 -name seqtk 2> /dev/null| grep -q 'seqtk' ; then
    SEQTK=$(find ${PATH//:/ } -maxdepth 1 -name seqtk 2> /dev/null | head -1)
    echo "seqtk da dat dung duong dan"
  else
    echo "seqtk dat sai duong dan " $PATH"."
    numsofts=$((numsofts + 1))
  fi
}

setupsetq()
{
  if( find seqtk &>/dev/null );then
    echo "seqtk is already installed"
    else
      echo "Downloading seqtk..."
      git clone https://github.com/lh3/seqtk.git
      cd seqtk
      make
      chmod +x seqtk
      echo "cd .."
      #read answer
      cd ..
      #mv  gnuplot-* gnuplot
      #cp seqtk ../Downloads
  fi
}
##########
numsofts=0
checkingsetq
