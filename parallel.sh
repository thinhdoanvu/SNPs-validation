#!/bin/bash
checkingpara()
{
  echo "Checking parallel install"
  setuppara
  echo "Checking PATH for parallel..."
  if find ${PATH//:/ } -maxdepth 1 -name parallel 2> /dev/null| grep -q 'parallel' ; then
    PARALLEL=$(find ${PATH//:/ } -maxdepth 1 -name parallel 2> /dev/null | head -1)
    echo "parallel da dat dung duong dan"
  else
    echo "parallel dat sai duong dan " $PATH"."
    numsofts=$((numsofts + 1))
  fi
}

setuppara()
{
  if( find parallel &>/dev/null );then
    echo "parallel is already installed"
    else
      echo "Downloading parallel..."
      curl -L -O http://ftp.gnu.org/gnu/parallel/parallel-latest.tar.bz2
      tar xvjf parallel-latest.tar.bz2
      cd parallel*
      ./configure && make
      chmod +x ./src/parallel ./src/sem ./src/niceload ./src/sql
      cp src/parallel ./ && cp src/sem ./ && cp src/sql ./
      echo "cd .."
      #read answer
      cd ../
      mv parallel-20151222  parallel
      mv parallel-latest.tar.bz2 ../Downloads
  fi
}
##########
numsofts=0
checkingpara
