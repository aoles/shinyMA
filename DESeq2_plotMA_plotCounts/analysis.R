### analysis.R : my additional file ### 

library(DESeq2)
library(pasilla)
library(Biobase)
data(pasillaGenes)

# DE analysis of the pasilla dataset from Bioconductor
dds <- DESeqDataSetFromMatrix(counts(pasillaGenes),
                              pData(pasillaGenes)[,2:3],
                              ~ condition)

# compare treated vs untreated
dds$condition <- relevel(dds$condition, "untreated")
dds <- dds[rowSums(counts(dds)) > 0, ]

# run DESeq
dds <- DESeq(dds)
res <- results(dds)

# this object will be used to locate points from click events.
# take the log of x, so that points are 'close' in the log x axis
data <- with(res, cbind(baseMean, log2FoldChange))

# we set the ylim so need to use
ymax <- 2.5
data[,2] <- pmin(ymax, pmax(-ymax, data[,2]))
scale <- c(diff(range(data[,1])), 2*ymax)
t.data.scaled <- t(data)/scale
