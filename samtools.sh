#!/bin/bash
checkingsam()
{
  echo "Checking bwa install"
  setupsam
  echo "Checking PATH for bwa..."
  if find ${PATH//:/ } -maxdepth 1 -name samtools 2> /dev/null| grep -q 'samtools' ; then
    SAMTOOLS=$(find ${PATH//:/ } -maxdepth 1 -name samtools 2> /dev/null | head -1)
    echo "samtools da dat dung duong dan"
  else
    echo "samtools dat sai duong dan " $PATH"."
    numsofts=$((numsofts + 1))
  fi
}

setupsam()
{
  if( find samtools &>/dev/null );then
    echo "samtools is already installed"
    else
      echo "Downloading samtools..."
      echo "curl -L -o samtools-0.x.tar.bz2 http://sourceforge.net/projects/samtools/files/samtools/0.1.19/samtools-0.1.19.tar.bz2/download"
      #read answer
      curl -L -o samtools-0.x.tar.bz2 http://sourceforge.net/projects/samtools/files/samtools/0.1.19/samtools-0.1.19.tar.bz2/download
      tar xvjf samtools-0.x.tar.bz2
      cd samtools-0.1*
      make
      chmod +x samtools
      echo "cd .."
      #read answer
      cd ..
      mv samtools-0.1.19 samtools
      cd ..
      mv samtools-0.1.19.tar.bz2 ../Downloads
  fi
}
##########
numsofts=0
checkingsam
