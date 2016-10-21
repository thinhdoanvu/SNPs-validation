#!/bin/bash
checkingfastx()
{
  echo "Checking fastx-toolkit install"
  setupfastx
  echo "Checking PATH for fastx-toolkit..."
  if find ${PATH//:/ } -maxdepth 1 -name fastq* 2> /dev/null| grep -q 'fastq-mcf' ; then
    FASTQ=$(find ${PATH//:/ } -maxdepth 1 -name fastq-mcf 2> /dev/null | head -1)
    echo "fastq-toolkit is right PATH"
  else
    echo "fastq-toolkit is wrong " $PATH"."
    numsofts=$((numsofts + 1))
  fi
}

setupfastx()
{
  if( find ea-utils &>/dev/null );then
    echo "fastx-toolkit is already installed"
    else
      echo "Downloading eautils for fast-toolkit..."
      echo "curl -O https://ea-utils.googlecode.com/files/ea-utils.1.1.2-537.tar.gz"
      #read answer
      curl -O https://ea-utils.googlecode.com/files/ea-utils.1.1.2-537.tar.gz
      tar -zxvf ea-utils.1.1.2-537.tar.gz
      echo "cd ea-utils.1.1.2-537"
      mv ea-utils.1.1.2-537 ea-utils
      cd ea-utils
      #read answer
      echo "make"
      make
      echo "sudo make install"
      sudo make install
      cd ../
      echo "moving file to Downloads folder"
      mv ea-utils.1.1.2-537.tar.gz ../Downloads
  fi
}
##########
numsofts=0
checkingfastx
