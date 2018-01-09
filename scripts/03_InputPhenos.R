#03_InputPhenos.R
#Nicole E Soltis
#121817

#-------------------------------------------------
# read in all phenotype files
rm(list=ls())
setwd("~/Projects/LsBcGWAS/images/Rep_01/05_extractFeat/Results")
ResultsFiles <- list.files(pattern = ".csv")
myresults_big <- as.data.frame(NULL)
for(f in 1:length(ResultsFiles)) {
  myresults <- read.csv(ResultsFiles[f])
  names(myresults)[1] <- "Object"
  myresults <- rbind(myresults_big, myresults)
  myresults_big <- myresults
}
write.csv(myresults, "CombinedResults_LsBc01.csv")

# read in all phenotype files
rm(list=ls())
setwd("~/Projects/LsBcGWAS/images/Rep_02/05_extractFeat/Results")
ResultsFiles <- list.files(pattern = ".csv")
myresults_big <- as.data.frame(NULL)
for(f in 1:length(ResultsFiles)) {
  myresults <- read.csv(ResultsFiles[f])
  names(myresults)[1] <- "Object"
  myresults <- rbind(myresults_big, myresults)
  myresults_big <- myresults
}
write.csv(myresults, "CombinedResults_LsBc02.csv")
