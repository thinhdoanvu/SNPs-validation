library(gplots)
library(RColorBrewer)

#########################################################
### reading in data and transform it to matrix format
#########################################################

#data <- read.csv("E:/results/", comment.char="#")
data <- read.csv("~/USC2016/GOTermFinder/Tissue/task3.csv", comment.char="#")
rnames <- data[,1]            # truc toa do ben trai la column 1 to "rnames"
mat_data <- data.matrix(data[,2:5])  # transform column 2-5 into a matrix
rownames(mat_data) <- rnames                  # assign row names

#########################################################
### customizing and plotting heatmap
#########################################################

# creates a own color palette from red to green
my_palette <- colorRampPalette(c("yellow", "red", "green"))(n = 299)

# (optional) defines the color breaks manually for a "skewed" color transition
col_breaks = c(seq(0,1,length=100),   # for red
               seq(2,20,length=100),           # for yellow
               seq(21,50,length=100))


# creates a 5 x 5 inch image
png("~/USC2016/GOTermFinder/Tissue/task3_week3",
    width = 5*300,        # 5 x 300 pixels
    height = 5*300,
    res = 300,            # 300 pixels per inch
    pointsize = 8)        # smaller font size

heatmap.2(mat_data,
          cellnote = mat_data,  # same data set for cell labels
          #main = "Correlation", # heat map title
          notecol="black",      # change font color of cell labels to black
          density.info="none",  # turns off density plot inside color legend
          trace="none",         # turns off trace lines inside the heat map
          margins =c(3,9),     # widens margins around plot
          col=my_palette,       # use on color palette defined earlier
          breaks=col_breaks,    # enable color transition at specified limits
          dendrogram="none",     # only draw a row dendrogram
          Colv="col")            # turn off column clustering , none , col hoac row

##############################################################################
# NOTE
##############################################################################
# The color breaks above will yield a warning
#    "...unsorted 'breaks' will be sorted before use" since they contain
#    (due to the negative numbers). To avoid this warning, you can change the
#    manual breaks to:
#
#  col_breaks = c(seq(0,1,length=100),   # for red
#    seq(1.01,1.7,length=100),           # for yellow
#    seq(1.71,2,length=100))             # for green
#
# However, the problem is then that our heatmap contains negative values
# which will then not be colored correctly. Remember that you don't need to
# provide manual color breaks at all, this is entirely optional.
##############################################################################

dev.off()

