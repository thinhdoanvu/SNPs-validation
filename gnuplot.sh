#!/bin/bash
checkinggnu()
{
  echo "Checking gnu install"
  setupgnu
  echo "Checking PATH for gnu..."
  if find ${PATH//:/ } -maxdepth 1 -name gnuplot 2> /dev/null| grep -q 'gnuplot' ; then
    GNUPLOT=$(find ${PATH//:/ } -maxdepth 1 -name gnuplot 2> /dev/null | head -1)
    echo "gnuplot da dat dung duong dan"
  else
    echo "gnuplot dat sai duong dan " $PATH"."
    numsofts=$((numsofts + 1))
  fi
}

setupgnu()
{
  if( find gnuplot &>/dev/null );then
    echo "gnuplot is already installed"
    else
      echo "Downloading gnuplot..."
      curl -L -o gnuplot.tar.gz http://sourceforge.net/projects/gnuplot/files/gnuplot/5.0.1/gnuplot-5.0.1.tar.gz/download      

      tar xvzf gnuplot.x.tar.gz 
      cd gnuplot-* 
      ./configure
      make
      make install
      echo "cd .."
      #read answer
      cd ..
      mv  gnuplot-* gnuplot
      mv gnuplot.x.tar.gz ../Downloads
  fi
}
##########
numsofts=0
checkinggnu
