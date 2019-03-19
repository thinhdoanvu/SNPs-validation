#!/bin/bash

###Script to check for and install most of the required software for dDocent

if [[ -z "$1" ]]; then
echo "Correct usage is sh install_dDocent_requirements [directory in your computer or user PATH]"
echo "if installing for all users, best to run this script as root"
exit 1
fi

INSTALL_PATH=$1



if type -p java; then
    _java=java
elif [[ -n "$JAVA_HOME" ]] && [[ -x "$JAVA_HOME/bin/java" ]];  then
    _java="$JAVA_HOME/bin/java"
else
    echo "no java"
fi

if [[ "$_java" ]]; then
    version=$("$_java" -version 2>&1 | awk -F '"' '/version/ {print $2}')
    echo version "$version"
    if [[ "$version" > "1.7" ]]; then
        echo version is greater than 1.7
    else         
        echo version is less than 1.7 please upgrade version
        exit 1
    fi
fi

echo "Checking for required software"


if [ -f $INSTALL_PATH/GenomeAnalysisTK.jar ]; then
    echo "GATK is already installed"
else
	echo "Please install GATK.  Follow this link to download and install. http://www.broadinstitute.org/gatk/auth?package=GATK"
fi

echo "Checking for STACKS"
if which clone_filter >/dev/null; then
    echo "STACKS is already installed"
else
	echo "Downloading and installing STACKS components clone_filter and process_radtags"
	curl -O http://creskolab.uoregon.edu/stacks/source/stacks-1.12.tar.gz
	tar xvzf stacks-1.12.tar.gz
	cd stacks-1.12
	./configure
	make
	cp clone_filter process_radtags $INSTALL_PATH
	cd ..
fi

echo "Checking for FreeBayes"
if which freebayes >/dev/null; then
    echo "FreeBayes is already installed"
else
        echo "Downloading and installing FreeBayes"
	git clone --recursive git://github.com/ekg/freebayes.git
        cd freebayes
        make
	cd bin
	cp * $INSTALL_PATH
	cd ..
	cd ..
fi
echo "Checking for cutadapt"
if which cutadapt >/dev/null; then
    echo "cutadapt is already installed"
else
	sudo apt-get install python3-dev
	sudo apt-get -y install python3-pip
	sudo python3 -m pip install cutadapt
	sudo python3 -m venv /usr/local/cutadapt
	sudo apt-get install python3-venv
	sudo /usr/local/cutadapt/bin/pip install cutadapt
	cd /usr/local/bin/
	sudo ln -s ../cutadapt/bin/cutadapt
fi

echo "Checking for fastqc"
if which cutadapt >/dev/null; then
    echo "fastqc is already installed"
else
	"Downloading and installing fastqc"
	curl -O http://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.10.1.zip
	unzip fastqc_v0.10.1.zip
	cd FastQC
	cp fastqc $INSTALL_PATH
	cd ..
fi

echo "Checking for trim_galore"
if which trim_galore >/dev/null; then
    echo "trim_galore is already installed"
else
	"Downloading and installing trim_galore"
	curl -O http://www.bioinformatics.babraham.ac.uk/projects/trim_galore/trim_galore_v0.3.3.zip
	unzip trim_galore_v0.3.3.zip
	cp trim_galore $INSTALL_PATH
fi

echo "Checking for mawk"
if which mawk >/dev/null; then
    echo "mawk is already installed"
else
	"Downloading and installing mawk"
	curl -O http://invisible-island.net/datafiles/release/mawk.tar.gz
	tar xvzf mawk.tar.gz
	cd mawk-1.*
	./configure
	make
	cp mawk $INSTALL_PATH
	cd ..
fi

echo "Checking for bwa"
if which bwa >/dev/null; then
    echo "bwa is already installed"
else
    echo "Downloading and installing bwa"
	git clone https://github.com/lh3/bwa.git
	cd bwa
	make
	cp bwa $INSTALL_PATH
	cd ..
fi


echo "Checking for samtools"
if which samtools >/dev/null; then
    echo "samtools is already installed"
else
	"Downloading and installing samtools"
	curl -L -o samtools-0.x.tar.bz2 http://sourceforge.net/projects/samtools/files/latest/download?source=files
	tar xvjf samtools-0.x.tar.bz2
	cd samtools-0.1*
	make
	cp samtools $INSTALL_PATH
	cd ..
fi

echo "Checking for VCFtools"
if which vcftools >/dev/null; then
    echo "VCFtools is already installed"
else
	echo "Downloading and installing VCFtools"
	curl -L -o vcftools_x.tar.gz http://downloads.sourceforge.net/project/vcftools/vcftools_0.1.11.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fvcftools%2Ffiles%2F%3Fsource%3Dnavbar&ts=1398959218&use_mirror=hivelocity
	tar xvzf vcftools_x.tar.gz
	cd vcftools_0*
	make
	cp ./bin/vcftools $INSTALL_PATH
	cd ..
fi

echo "Checking for Rainbow"
if which rainbow >/dev/null; then
    echo "Rainbow is already installed"
else
	echo "Downloading and installing Rainbow"
	curl -L -o rainbow.x.tar.gz http://sourceforge.net/projects/bio-rainbow/files/latest/download?source=files
	tar xvzf rainbow.x.tar.gz
	cd rainbow_*
	make
	cp rainbow rbasm rbmergetag select_* $INSTALL_PATH	
	cd ..
fi

echo "Checking for seqtk"
if which seqtk >/dev/null; then
    echo "seqtk is already installed"
else
    	echo "Downloading and installing seqtk"
	git clone https://github.com/lh3/seqtk.git
	cd seqtk
	make
	cp seqtk $INSTALL_PATH	
	cd ..
fi

echo "Checking for cd-hit"
if which cd-hit-est >/dev/null; then
    echo "cd-hit is already installed"
else
	echo "Downloading and installing cd-hit"
	curl -O http://www.bioinformatics.org/downloads/index.php/cd-hit/cd-hit-v4.5.4-2011-03-07.tgz
	tar xvzf cd-hit-v4.5.4-2011-03-07.tgz
	cd cd-hit-v4.5.4-2011-03-07
	make openmp=yes
	cp cd-hit-est cd-hit-est-2d $INSTALL_PATH
	cd ..
fi

echo "Checking for mergefq.pl"
if [ -f $INSTALL_PATH/mergefq.pl ]; then
	echo "mergefq.pl already installed"
else
	curl -O https://github.com/McKayDavis/dDocent/raw/master/mergefq.pl	
	cp mergefq.pl $INSTALL_PATH
fi

echo "Checking for Seq_filter.pl"
if [ -f $INSTALL_PATH/Seq_filter.pl ]; then
	echo "Seq_filter.pl already installed"
else
	curl -O http://seq-filter.googlecode.com/files/Seq_filter.pl
	cp Seq_filter.pl $INSTALL_PATH
fi

echo "Checking for cutseq_fasta.pl"
if [ -f $INSTALL_PATH/cutseq_fasta.pl ]; then
	echo "cutseq_fasta.pl already installed"
else
	curl -O http://nash-bioinformatics-codelets.googlecode.com/files/cutseq_fasta.pl
	cp cutseq_fasta.pl $INSTALL_PATH
fi

echo "Checking for bedtools"
if which bamToBed >/dev/null; then
    	echo "bedtools is already installed"
else
	curl -L -O https://github.com/arq5x/bedtools2/releases/download/v2.19.1/bedtools-2.19.1.tar.gz
	tar xvzf bedtools-2.19.1.tar.gz
	cd bedtools2-2.19.1
	make 
	cd bin
	cp * $INSTALL_PATH
	cd ..
	cd ..
fi

echo "Now installing dDocent"
	curl -L -O https://github.com/jpuritz/dDocent/raw/master/dDocent.GATK
	chmod +x dDocent.GATK
	cp dDocent.GATK $INSTALL_PATH



