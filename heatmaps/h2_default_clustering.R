library(gplots)
library(RColorBrewer)

#########################################################
### reading in data and transform it to matrix format
#########################################################

data <- read.csv("dataset.csv", comment.char="#")
rnames <- data[,1]                            # assign labels in column 1 to "rnames"
mat_data <- data.matrix(data[,2:ncol(data)])  # transform column 2-5 into a matrix
rownames(mat_data) <- rnames                  # assign row names



#########################################################
### customizing and plotting heatmap
#########################################################

# creates a own color palette from red to green
my_palette <- colorRampPalette(c("red", "yellow", "green"))(n = 299)

# creates a 5 x 5 inch image
png("h2_default_clustering.png",
  width = 5*300,        # 5 x 300 pixels
  height = 5*300,
  res = 300,            # 300 pixels per inch
  pointsize = 8)        # smaller font size

# changes the distance measure and clustering method
# NOTE: Matrix here not symmetrical. For symmetrical matrices
# only one distance and cluster could and SHOULD be defined.
# Distance options: euclidean (default), maximum, canberra, binary, minkowski, manhattan
# Cluster options: complete (default), single, average, mcquitty, median, centroid, ward
row_distance = dist(mat_data, method = "manhattan")
row_cluster = hclust(row_distance, method = "ward.D")
col_distance = dist(t(mat_data), method = "manhattan")
col_cluster = hclust(col_distance, method = "ward.D")

heatmap.2(mat_data,
  cellnote = mat_data,  # same data set for cell labels
  main = "Correlation", # heat map title
  notecol = "black",      # change font color of cell labels to black#
  density.info = "none",  # turns off density plot inside color legend
  trace = "none",         # turns off trace lines inside the heat map
  margins = c(12,9),     # widens margins around plot
  col = my_palette,       # use on color palette defined earlier
  Rowv = as.dendrogram(row_cluster), # apply default clustering method
  Colv = as.dendrogram(col_cluster)) # apply default clustering method

dev.off()
