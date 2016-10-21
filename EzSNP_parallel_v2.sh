#BEGIN

#Get CPU cores
cpu_num=$(grep -c ^processor /proc/cpuinfo 2> /dev/null)
cpu_num=$((cpu_num+0))

checkans()
{
  echo "Do you want to check Individuals name ?"
  read CHKname
  echo "Do you want to cut dapter and quality sequences?"
  read CHKcut
  echo "Do you want to make reference genome ?"
  read CHKref
  echo "Do you want to make alignment ?"
  read CHKaln
  echo "Do you want to call SNP ?"
  read CHKsnp

  if [ $CHKname == "yes" ]
    then
      checkindv
  fi

  if [ $CHKcut == "yes" ]
    then
      trimming
    else
    a=$(ls clip* | wc -l)
    if [ $a -eq 0 ]
      then
        exit 1;
    fi
  fi

  if [ $CHKref == "yes" ]
    then
      assembly
    else
    a=$(ls reference* | wc -l)
    if [ $a -eq 0 ]
      then
        exit 1;
    fi
  fi

  if [ $CHKaln == "yes" ]
    then
      samtool
    else
    a=$(ls *sam | wc -l)
    if [ $a -eq 0 ]
      then
        exit 1;
    fi
  fi
  if [ $CHKsnp == "yes" ]
    then
      callsnp
    else
    a=$(ls *vcf | wc -l)
    if [ $a -eq 0 ]
      then
        exit 1;
    fi
  fi

}
#----------------------------------------------------------------#
#----------------------------------------------------------------#
#----------------------------------------------------------------#
#----------------------------------------------------------------#
checkindv()
{
  echo "Now, I am going to process every things for you...PLEASE, sit back until I say you relax"
  ls *gz >namelist
  numnames=$(cat namelist)
  numindv=$(ls *R*gz | wc -l)
  numindvs=$(( $numindv /2 ))
  #checking name files
  if (( $numindv % 2 !=0 )); then
    echo "Checking your individuals, u may lost at lest 1 file!PLEASE checking files again"
    ls
    else
     echo "Do u have "$numindvs" individuals?"
     read answer
     if [ "$answer" == "no"  ]; then
       echo "U need to check name files of your sequences"
       echo "Do you want to exit?"
       read answer
       if [ "$answer" == "yes" ]; then
         exit 1;
         else
           ls *gz
       fi
     #rename files
     else
       echo "Do u want to rename all off files?"
       read answer
       if [ "$answer" == "yes" ];then
         renamefi
         else
          ls
       fi
    fi
  echo "Now, press Ctrl + Z and go relax..."
  fi
}
#----------------------------------------------------------------#
#Function to rename files
renamefi()
{
  echo "rename all file..."
  #STEP 0.
  ls *gz >namelist
  awk '!/namelist/' namelist >namelist0
  #Hien thi danh sach file khong bao gom file co ten la list
  #SB-AG1_CTGAAGCT-TATAGCCT_L006_R1_001.fastq.gz
  #SB-AG1_CTGAAGCT-TATAGCCT_L006_R2_001.fastq.gz

  #STEP 1.
  sed 's/R1_001/F/;s/R2_001/R/' namelist0 >namelist1
  #Doi ten file thanh F.fastq.gz va R.fastq.gz
  #SB-AG1_CTGAAGCT-TATAGCCT_L006_F.fastq.gz
  #SB-AG1_CTGAAGCT-TATAGCCT_L006_R.fastq.gz

  #STEP 2.
  awk '{print ">" substr($0,0,index($0,"_"))"."}' namelist1 > namelist2
  #	>SB-AG1.

  #STEP 3.
  sed 's/.*_//' namelist1 > namelist3
  #	F.fastq.gz
  #	R.fastq.gz

  #STEP4.
  #>SB-AG1.	F.fastq.gz
  #>SB-AG1.	R.fastq.gz
  paste namelist2 namelist3 > namelist4

  #STEP 5.
  #	>SB-AG1.F.fastq.gz
  #	>SB-AG1.R.fastq.gz
  sed 's/\t//' namelist4 > namelist5

  #STEP 6.
  #	CTGAAGCT-TATAGCCT
  awk '{print substr($0,index($0,"_")+1,index($0,"_L")-index($0,"_")-1)}' namelist0 > namelist6

  #STEP 7.
  #	CTGAAGCT-TATAGCCT
  sed 's/-//' namelist6 > namelist7
  #	CTGAAGCTTATAGCCT

  #STEP 8.
  #	>SB-AG1.F.fastq.gz CTGAAGCTTATAGCCT
  paste namelist5 namelist7 > namelist8

  #STEP 9.
  #	>SB-AG1.F.fastq.gz 
  #	CTGAAGCTTATAGCCT
  sed 's/\t/\n/' namelist8 > adapter.fa


  #..........RENAMING FILE NAME..........#

  #REN 1.  
  #	mv SB-AG1_CTGAAGCT-TATAGCCT_L006_R1_001.fastq.gz
  awk '{print "mv " $0}' namelist0 > rename1

  #REN 2. 
  #	>SB-AG1.F.fastq.gz 
  #	SB-AG1.F.fastq.gz 
  sed 's/>//' namelist5 > rename2

  #REN 3.
  # 	mv SB-AG1_CTGAAGCT-TATAGCCT_L006_R1_001.fastq.gz	SB-AG1.F.fastq.gz 
  paste rename1 rename2 > adapter.sh

  #DELETE ALL FILEs
  #STEP 10.
  #remove all namelist file
  rm namelist*
  rm rename1 && rm rename2

  #mv adapter.sh ../

  # RUN FILES
  #chmod 755 ../adapter.sh
  #../adapter.sh

  #run command from file
  awk '{print $0}' adapter.sh | xargs -0 bash -c

  rm adapter.sh
 }

#triming adapter and quality
trimming()
{
  ls *F.fastq.gz > namelist
  sed -i -e 's/.F.fastq.gz//g;s/_//' namelist
  #Chi lay lai ten ca the: TB-AG1
  NAMES=$(cat namelist)
  for i in $NAMES
  do
    fastq-mcf adapter.fa $i.F.fastq.gz $i.R.fastq.gz -o clip_$i.F.fastq.gz -o clip_$i.R.fastq.gz -q 20
  done
}

#assembly contigs
assembly()
{
  echo "catting forward..."
  zcat clip*F* > forward
  echo "catting reverse..."
  zcat clip*R* > reverse
  echo "rbcluster.out..."
  rainbow cluster -1 forward -2 reverse > rbcluster.out 2> log
  echo "rbdiv.out"
  rainbow div -i rbcluster.out -o rbdiv.out -f 0.5 -K 10
  echo "rbasm.out..."
  rbasm -o rbasm.out -i rbdiv.out
  echo "select_best_rbcontig.pl..."
  perl ~/programs/rainbow/select_best_rbcontig.pl rbasm.out > referencegenome
  echo "referencegenome...."
  bwa index -a bwtsw referencegenome
}


#samtools
samtool()
{
  ls clip*F.fastq.gz > namelist
  sed -i -e 's/.F.fastq.gz//g;s/clip//;s/_//' namelist

#clean file source
NAMES=$(cat namelist)
for i in $NAMES
  do
    rm $i.F.fastq.gz
    rm $i.R.fastq.gz
  done

#make sam file

ls clip*F* | sed 's/clip_//' | sed 's/.F.fastq.gz//'| shuf | parallel --no-notice --delay 1 'bwa mem referencegenome clip_{}.F.fastq.gz clip_{}.R.fastq.gz -R "@RG\tID:{}\tSM:{}\tPL:Illumina" > {}.sam'

#sam to bam
ls *sam | sed 's/.sam//' | shuf | parallel --no-notice --delay 1 'samtools view -SbT referencegenome -q 1 {}.sam > {}.bam 2> {}.bam.log'

# sort va doi ten file
    
  for i in $NAMES
  do
    samtools sort -@$cpu_num $i.bam $i
    mv $i.bam $i-RG.bam
  done

#index bam file
ls *bam | shuf | parallel --no-notice --delay 1 'samtools index {}' 

#thuc hien tuan tu  
#  NAMES=$(cat namelist)  
#  for i in $NAMES
#  do
#    if [ -f $i.F.fastq.gz ];then
#      bwa mem -t $cpu_num referencegenome clip_$i.F.fastq.gz clip_$i.R.fastq.gz -R "@RG\tID:$i\tSM:$i\tPL:Illumina" 2> bwa.$i.log | samtools view -SbT referencegenome -q 1 - > $i.bam 2> $i.bam.log
#    fi
#    samtools sort -@$cpu_num $i.bam $i
#    mv $i.bam $i-RG.bam
#    samtools index $i-RG.bam
#  done
}

#call snp by freebayes
callsnp()
{
  ls *-RG.bam >bamlist.list
  bamtools merge -list bamlist.list | samtools rmdup - cat-RRG.bam &>/dev/null
  bamToBed -i cat-RRG.bam > map.bed
  bedtools merge -i map.bed > mapped.bed

  coverageBed -abam cat-RRG.bam -b mapped.bed -counts > cov.stats	

  DP=$(mawk '{print $4}' cov.stats | sort -rn | perl -e '$d=.005;@l=<>;print $l[int($d*@l)]')
  CC=$( mawk -v x=$DP '$4 < x' cov.stats | mawk '{len=$3-$2;lc=len*$4;tl=tl+lc} END {OFMT = "%.0f";print tl/1000}')
	 
  mawk -v x=$DP '$4 < x' cov.stats |sort -V -k1,1 -k2,2 | mawk -v cutoff=$CC 'BEGIN{i=1} 
  {
  len=$3-$2;lc=len*$4;cov = cov + lc
  if ( cov < cutoff) {x="mapped."i".bed";print $1"\t"$2"\t"$3 > x}
  else {i=i+1; x="mapped."i".bed"; print $1"\t"$2"\t"$3 > x; cov=0}
  }' 

#tao popmap
  awk '{print substr($0,index($0,"-")+1,length($0)-index($0,"-")-1)}' namelist >p
  paste namelist p >popmap
  rm p

  ls mapped.*.bed | sed 's/mapped.//g' | sed 's/.bed//g' | shuf | parallel --no-notice --delay 1 freebayes -L bamlist.list -t mapped.{}.bed -v raw.{}.vcf -f referencegenome -m 5 -q 5 -E 3 --min-repeat-entropy 1 -V --populations popmap -n 10

  rm mapped.*.bed 
  mv raw.1.vcf raw.01.vcf
  mv raw.2.vcf raw.02.vcf
  mv raw.3.vcf raw.03.vcf
  mv raw.4.vcf raw.04.vcf
  mv raw.5.vcf raw.05.vcf
  mv raw.6.vcf raw.06.vcf
  mv raw.7.vcf raw.07.vcf
  mv raw.8.vcf raw.08.vcf
  mv raw.9.vcf raw.09.vcf

#combine vcf
  if [ ! -d "RAWSNP" ]; then
    mkdir RAWSNP
  fi
  mv raw.*.vcf ./RAWSNP
  cd RAWSNP
  vcfcombine raw.*.vcf | sed -e 's/	\.\:/	\.\/\.\:/g' > rawsnp.vcf
}
#call functions here
checkans
