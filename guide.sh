#STEP1: CHUAN BI PHAN MEM
#download GO:Termfinder tool from cpan: 
wget http://search.cpan.org/CPAN/authors/id/S/SH/SHERLOCK/GO-TermFinder-0.86.tar.gz
#This is file: go-perl-0.15.tar.gz
#Extract this file:
tar -zxvf go-perl-0.15.tar.gz
#Intall GO::Termfinder
perl Makefile.PL
make
make test
sudo make install
#Copy analyze.pl, genes.txt from "example" folder to "t" folder
cp /path/to/example/analyze.pl /path/to/t/
cp /path/to/example/genes.txt /path/to/t/
#STEP 2: CHUAN BI DATA - File dau vao la: Input tu hom Task2 da duoc chinh sua
#1. Ky tu @ o dau dong
#2. Cac Tissue ma chua ky tu trang
#Tao ra 1 file chi co cot so 3 va 5 - Nhu the nay:
#oki.52.118	184186107#GTPase homolog [Strongylocentrotus purpuratus]	gi|184186107|ref|NP_001116975.1|#GTPase homolog [Strongylocentrotus purpuratus]	19#GO:0005622#intracellular#cellular_component,GO:0043025#neuronal cell body#cellular_component,GO:0007409#axonogenesis#biological_process,GO:0051223#regulation of protein.....

awk '!/@/' Input | cut -f3,7 >oki_go.input

#Loc lay cac oki -> uniq de co duoc so luong oki dong nhat - XOA DONG DAU TIEN DO CO KHOANG TRANG - SED
cut -f1 oki_go.input | sort | uniq | sed -e "1d"  > oki_uniq

# Tach moi oki thanh 1 file va moi file se chi chua GO (co cai khong co GO) luu vao thu muc oki
#Trong moi file oki nay chi loc lay phan GO va moi GO xuong 1 hang
mkdir oki
tam=$(cat oki_uniq)

for i in $tam; do grep $i oki_go.input | cut -f2 | awk '{print substr($0,index($0,"#")+1,length($0))}' | sed 's/#/\n/g;s/,/\n/g' | grep "GO" | awk '!/No/' >oki/$i; done

#Tim cac file co dung luong =0 

cd oki
find . -type f -size 0 >../emptylist

# chuyen cac file co dung luong trong vao thu muc empty
cd ../

mkdir empty
awk '{print substr($0,index($0,"/")+1,length($0))}' emptylist >zerofile
rm emptylist
tam=$(cat zerofile)
for i in $tam; do mv oki/$i empty/$i; done

#va viet vao do GO:0008150
for i in $tam; do echo "GO:0008150" >>empty/$i; done

#Chen ten file vao cot thu nhat cua noi dung file
#oki.9.84	GO:0030216
#oki.9.84	GO:0001533
#oki.9.84	GO:0005913

#Lam cho thu muc empty truoc
cd empty
for i in *; do nawk '{print FILENAME"\t"$0}' $i > $i.bk; mv $i.bk $i; done

#lam cho thu muc oki
cd ../oki
for i in *; do nawk '{print FILENAME"\t"$0}' $i > $i.bk; mv $i.bk $i; done

cd ..

#Noi tat cac cac file cua thu muc emty thanh 1 file -oki.empty
cat empty/* >oki.empty

#Noi tat ca cac file cua thu muc oki thanh 1 file oki.content
cat oki/* >oki.content

#Noi 2 file tren thanh 1 file - oki.go
cat oki.empty oki.content >oki.go

#Tao ra bang tra Biology Process(P), Cellular Component (C), Molecular Function (F) cho cac GO
#Trong do: GO:0008150 la P
cut -f7 Input | awk '{print substr($0,index($0,"#")+1,length($0))}' | sed 's/,GO/\nGO/g' | awk '!/No/' | awk '!/annotation/' | sed 's/#/\t/g' | cut -f1,3 | sort | uniq | sed 's/,//g' >go_function

#Mo bang EXCEL va tao bang tra, nho chen them 1 dong la: GO:0008150 va ky hieu la P
#1. Mo file go_function bang Excel
#2. Sua dong trong dau tien thanh: GO:0008150 -cot2: biology process
#3. Tao bang tra VLOOKUP
#4. Tra bang, ket qua duoc cot so 4 P, C, F

#Them 1 SHEET de paste noi dung cua file oki.go vao. Sau do lay noi dung cua sheet go_function lam bang tra cho du lieu moi
#Khi tra xong can filter de co the co nhung dong N/A. Kien tra lia dong nao N/A - doc file Input de dien , P, F, C

#Them 1 sheet de tra bang cho oki.x.x - Moi oki chi co 1 con so duy nhat nen 
#Tao oki uniq 
# gan so trong Exel va dung ham VLOOKUP

cut -f1 oki.go | sort | uniq >oki_function
#Mo oki_function - paste sang excel
#danh so thu tu cho cac oki nay
#Dung ham VLOKUP de tra bang cho sheet GO - Co nhieu hang nhat --hehe

##########VO CUNG QUAN TRONG NE###########
#COPY FILE EXCEL ra 1 file nua

#FILE : go_function

#FILE CUOI CUNG LA FILE CHUA 4 cot oki.9.84,GO:0046872,F,447

#thay the cac ky tu , thanh \t va luu file moi: final_component
sed 's/,/\t/g' go_function > final_component

#dem so hang cua final_component va tien hanh cat file mau dung bang so hang nhu vay
#10.585
awk '!/!/' gene_association.sgd| head -10585 | cut -f1 >usc.c1
awk '!/!/' gene_association.sgd| head -10585 | cut -f2 >usc.c2
awk '!/!/' gene_association.sgd| head -10585 | cut -f3 >usc.c3
awk '!/!/' gene_association.sgd| head -10585 | cut -f4 >usc.c4
awk '!/!/' gene_association.sgd| head -10585 | cut -f5 >usc.c5
awk '!/!/' gene_association.sgd| head -10585 | cut -f6 >usc.c6
awk '!/!/' gene_association.sgd| head -10585 | cut -f7 >usc.c7
awk '!/!/' gene_association.sgd| head -10585 | cut -f8 >usc.c8
awk '!/!/' gene_association.sgd| head -10585 | cut -f9 >usc.c9
awk '!/!/' gene_association.sgd| head -10585 | cut -f10 >usc.c10
awk '!/!/' gene_association.sgd| head -10585 | cut -f11 >usc.c11
awk '!/!/' gene_association.sgd| head -10585 | cut -f12 >usc.c12
awk '!/!/' gene_association.sgd| head -10585 | cut -f13 >usc.c13
awk '!/!/' gene_association.sgd| head -10585 | cut -f14 >usc.c14
awk '!/!/' gene_association.sgd| head -10585 | cut -f15 >usc.c15

#thay the cac cot 2,3,5,9 tu file final_component
#2. number
#3. oki
#5. GO
#9. F,P,C
cut -f1 final_component >../../GO-TermFinder-0.86/t/usc.c3
cut -f2 final_component >../../GO-TermFinder-0.86/t/usc.c5
cut -f3 final_component >../../GO-TermFinder-0.86/t/usc.c9
cut -f4 final_component >../../GO-TermFinder-0.86/t/usc.c2

#Gop cac cot thanh 1 file usc.sgd
paste usc.c1 usc.c2 usc.c3 usc.c4 usc.c5 usc.c6 usc.c7 usc.c8 usc.c9 usc.c10 usc.c11 usc.c12 usc.c13 usc.c14 usc.c15 > usc.sgd

#tao file genes.txt
cut -f1 final_component | sort | uniq >../../GO-TermFinder-0.86/t/okilist.txt

#RUN



