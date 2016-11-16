echo "execute by PCAdapt..."
wget http://membres-timc.imag.fr/Michael.Blum/PCAdapt/ArchivePCAdapt.tar.gz
tar -zxvf ArchivePCAdapt.tar.gz
#mv PCAdaptPackage/* ./ && rm PCAdaptPackage
echo "how to install"
make lapack
make
sudo make
####UPDATE .bash_profile
#!/bin/bash
PATH="/home/thinhdv/programs/stacks:/home/thinhdv/programs/:/home/thinhdv/programs/vcffilter:/home/thinhdv/programs/pear:/home/thinhdv/programs/parallel:/home/thinhdv/programs/bamtools:/home/thinhdv/programs/bedtools/bin:/home/thinhdv/programs/cd-hit:/home/thinhdv/programs/seqtk:/home/thinhdv/programs/gnuplot:/home/thinhdv/programs/vcftools:/home/thinhdv/programs/bwa:/home/thinhdv/programs/samtools:/home/thinhdv/programs/mawk:/home/thinhdv/programs/freebayes:/home/thinhdv/programs/cmake:/home/thinhdv/programs/trimmomatic:/home/thinhdv/programs/ea-utils:/home/thinhdv/programs/rainbow:/home/thinhdv/programs/PCAdapt${PATH}"
export PATH

source ~/.bash_profile

#step1. convert SNPs.vcf to PCAdapt
git clone https://github.com/zhanxw/vcf2geno.git
cd vcf2geno
cd src
make
cd ../executable
mv vcf2laser vcf2geno
#step 2: tao bash_profile
#step3 . thuc thi
./vcf2geno --inVcf ~/results/PHEN/raw.af.ac.dp.rmindel.hwe.Q30.geno.ab.vcf --out ~/results/PHEN/tam
#ket qua co  2 file: tam.geno va tam.site
#trong do file tam.geno co cau truc nhu sau:
#thua 2 cot dau tien (ten ca the)
#loai bo di lenh - thi moi co the thuc hien duoc bang PCAdapt
cut -f3- tam.geneo > PCAdapt_input.geno

#step4. thuc hien PCAdapt
tao file test K (chua cac so tu 1 - 100)
t=$(cat testK)
for i in $t
do
PCAdapt -i PCAdapt_input.geno -K $i -o outputK$i -t 1 -s 10000 -b 5000
done
#tai sao phai transpose (do du lieu cua minh la sample tren hang con SNPs tren cot trong khi PCAdapt thi nguoc lai)

#xem them o manual

#step5 choose K best
#mo R studio, sua source file
######################################## R BEGIN #######################################
file = "results/PHEN/outputK"

nK = 100
system("rm tmp")
for (k in 1:nK){
	system(paste("head -n 1 ", file, k, ".stats >> tmp", sep = ""))
}

err <- read.table("tmp")
plot(err[, 2], pch = 18, xlab = 'K', ylab = 'errors')

################################## R FILE OVER #########################################

#(nk=100 la do file testK, chi can outputK thi no se tu chon K voi prefix name file la: outputK$i)



# Chon lay cac K nao co SNPs la bao nhieu
ls *topBF >topBFfilename
tam=$(cat topBFfilename)
mkdir temp
#chi lay cot so 1 cua moi file, xoa cac ky tu xuong hang va thay bang dau , va xoa dau , o cuoi cung
for i in $tam ; do cut -f1 $i |tr '\n' ',' | sed -e '$a\' | awk '{print substr($0,1,length($0)-1)}'  >temp/$i; done
#Chen ten file vao dau cua moi noi dung file
rm topBFfilename
cd temp
for i in *; do nawk '{print FILENAME"\t"$0}' $i > $i.bk; mv $i.bk $i; done
#noi tat ca cac file thanh 1
cat *topBF >> Kvalue
#xoa cac file topBF
rm *topBF

#Sua file ket qua
sed 's/outputK/K=/g;s/.topBF//g;s/,/\t/g' Kvalue >BFfactor
rm Kvalue

#tao bang do nhiet cho cac SNP tuong ung voi cac K value
cut -f3 BFfactor | sort -u >SNPs
cut -f4 BFfactor | sort -u >>SNPs
sort -u SNPs >SNPsort
rm SNPs

#va bang do nhiet cho so luong suat hien cac SNPs
mkdir SNPcount
for i in $t; do grep -c $i SNPs >SNPcount/SNP$i; done
  ## Noi cac file co ten va noi dung lam 1 file
cd SNPcount
for i in *; do nawk '{print FILENAME"\t"$0}' $i > $i.bk; mv $i.bk $i; done

#noi tat ca lam 1 va sap xep theo cot so luong
cat * >> count
rm SNP*
cat * | sort -u | sort -k2n >count
#KQ: 
SNP24	2
SNP44	2
SNP46	2
SNP93	2
SNP14	5
SNP11	6
SNP10	8
SNP12	9
SNP5	9
SNP9	9
SNP6	12
SNP3	13

  


