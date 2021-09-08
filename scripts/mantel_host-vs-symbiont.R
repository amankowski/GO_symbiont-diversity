#!/usr/bin/env Rscript
## run from Rfiles/scripts !!!

mypaths<-c("/Users/amankows/Library/R/3.6/library", "/Library/Frameworks/R.framework/Versions/3.6/Resources/library")
.libPaths(mypaths)
.libPaths()
library("ape")
library("ggplot2")
library("vegan")
library("gridExtra")
library("plyr")
library("MASS")
library("gdata")
library("dplyr")
library("reshape2")
library("forcats")
library("ggdark")
library("patchwork")
library("phytools")
library("Hmisc")
library("optparse")
library("stringr")
library("spaa")
library("ade4")

option_list<-list(
  make_option("--symbiont", type="character", default=NULL),
  make_option("--input", type="character", default=NULL),
  make_option("--output", type="character", default=NULL))
opt_parser=OptionParser(option_list=option_list)
opt=parse_args(opt_parser)

symbiont=opt$symbiont

df<-read.csv(opt$input, sep=",", header=T)

df.sub<-df[ which(df$symbiont == symbiont), ]

host<-df.sub[c(2:4)]
host.matrix<-as.dist(xtabs(host[,3] ~ host[,2] + host[,1]))
sym<-df.sub[c(2,3,5)]
sym.matrix<-as.dist(xtabs(sym[,3] ~ sym[,2] + sym[,1]))
sym.mantel<-mantel.rtest(host.matrix, sym.matrix, nrepet=9999)
mantel.obs<-sym.mantel$obs
mantel.sign<-sym.mantel$pvalue
mantel.out<-data.frame(symbiont, mantel.obs, mantel.sign)
names(mantel.out)<-c("symbiont", "mantel", "pvalue")

write.table(mantel.out, file=opt$output, row.names=F, quote=F, sep="\t")