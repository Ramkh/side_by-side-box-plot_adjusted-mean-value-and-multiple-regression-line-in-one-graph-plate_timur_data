rm(list =ls())
aps<-read.table(file="clipboard",sep="\t", header = TRUE)
aps
head(aps)
attach(aps)
names(aps)
library(ggplot2)
library(Rmisc)
library(gridExtra)
library(reshape2)
library(plyr)


tgc <- summarySE(aps, measurevar="sympt", groupvars=c("Isolates","wilt"),na.rm = T)
tgc

o <- ggplot(tgc, aes(Isolates, sympt, fill=  wilt)) + geom_bar(stat="identity", color="black",
                                                               position=position_dodge())
p <-o + geom_errorbar(aes(ymin=sympt, ymax=sympt+se), width=.2,
                      position=position_dodge(.9)) +labs(x="Isolates", y="Wilt score")
p

library(RDCOMClient)
library(R2PPT)
#devtools::install_github("dkyleward/RDCOMClient")
temp_file<-paste(tempfile(),".wmf", sep="")
ggsave(temp_file, plot=p)

mkppt <- PPT.Init(method="RDCOMClient")
mkppt<-PPT.AddBlankSlide(mkppt)
mkppt<-PPT.AddGraphicstoSlide(mkppt, file=temp_file)
unlink(temp_file)
