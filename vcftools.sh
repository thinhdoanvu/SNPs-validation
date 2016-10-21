#!/bin/bash
checkingvcf()
{
  echo "Checking vcftools install"
  setupvcf
  echo "Checking PATH for vcftools..."
  if find ${PATH//:/ } -maxdepth 1 -name vcftools 2> /dev/null| grep -q 'vcftools' ; then
    VCFTOOLS=$(find ${PATH//:/ } -maxdepth 1 -name vcftools 2> /dev/null | head -1)
    echo "vcftools da dat dung duong dan"
  else
    echo "vcftools dat sai duong dan " $PATH"."
    numsofts=$((numsofts + 1))
  fi
}

setupvcf()
{
  if( find vcftools &>/dev/null );then
    echo "vcftools is already installed"
    else
      echo "Downloading vcftools..."
      curl -L -o vcftools_x.tar.gz "http://downloads.sourceforge.net/project/vcftools/vcftools_0.1.11.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fvcftools%2Ffiles%2F%3Fsource%3Dnavbar&ts=1398959218&use_mirror=hivelocity"	
      tar xvzf vcftools_x.tar.gz
      cd vcftools_0*
      make
      chmod +x ./bin/vcftools
      echo "cd .."
      #read answer
      cd ..
      mv vcftools_0.1.11 vcftools
      mv vcftools_x.tar.gz ../Downloads
  fi
}
##########
numsofts=0
checkingvcf
