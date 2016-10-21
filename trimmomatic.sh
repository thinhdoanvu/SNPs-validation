#!/bin/bash
checkingtrim()
{
  echo "Checking trimommatic install"
  setuptrim
  echo "Checking PATH for trimmomatic..."
  if find ${PATH//:/ } -maxdepth 1 -name trimmomatic*jar 2> /dev/null| grep -q 'trim' ; then
    TRIMMOMATIC=$(find ${PATH//:/ } -maxdepth 1 -name trimmomatic*jar 2> /dev/null | head -1)
    echo "trimmomatic da dat dung duong dan"
  else
    echo "trimmomatic dat sai duong dan " $PATH"."
    numsofts=$((numsofts + 1))
  fi
}

setuptrim()
{
  if( find trimmomatic &>/dev/null );then
    echo "trimmomatic is already installed"
    else
      echo "Downloading trimmomatic..."
      echo "curl -O http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.33.zip"
      #read answer
      curl -O http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.33.zip
      echo "cd trimmomatic"
      #read answer
      unzip Trimmomatic-0.33.zip
      mv Trimmomatic-0.33 trimmomatic
      cd trimmomatic
      mv trimmomatic-0.33.jar trimmomatic.jar
      cd ..
      mv Trimmomatic-0.33.zip ../Downloads
  fi
}
##########
numsofts=0
checkingtrim
