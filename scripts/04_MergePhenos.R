#04_MergePhenos.R
rm(list=ls())
setwd("~/Projects/LsBcGWAS/data/forBigRR")

#read in files
mydata_rep1 <- read.csv("CombinedResults_LsBc01.csv")
mydata_rep2 <- read.csv("CombinedResults_LsBc02.csv")
myfactors_rep1 <- read.csv("LsBcGWAS_allPhenos_rep01.csv")
myfactors_rep2 <- read.csv("LsBcGWAS_allPhenos_rep02.csv")
myplants_rep1 <- read.csv("LsBcGWAS_IndPlants_rep01.csv")
myplants_rep2 <- read.csv("LsBcGWAS_IndPlants_rep02.csv")
myruler <- read.csv("LsBcGWAS_rulers.csv")
myisolates <- read.csv("LsBcGWAS_IsolateKey.csv")
cisolates <- read.csv("Isolate_liste_Feb2017.csv")
mylettuce <- read.csv("LsVarieties_Soltis.csv")

#only keep the variables I want, and rename them
mydata_rep1 <- mydata_rep1[,c("Image","Object","Lesion.Size")]
mydata_rep2 <- mydata_rep2[,c("Image","Object","Lesion.Size")]
mylettuce <- mylettuce[,c("Nickname","FullID")]
names(mylettuce)[1] <- "LsGeno"
names(mylettuce)[2] <- "PlantGeno"
allisolates <- merge(myisolates,cisolates, by="Isolate")
allisolates <- allisolates[,c("Isolate","IsoIDSlBc01","C.name")]
names(allisolates)[1] <- "IsolateID"
names(allisolates)[2] <- "BcGeno_01"
names(allisolates)[3] <- "BcGeno_02"
#headers for Celine: Num_ID Exp Rep Flat Domest PlantGeno IndPlant IsolateID Scale.LS Taxon Wi_Do Full_key_plant Plant_isol Isolate_taxon_key

#extract letter from myfactors_rep1$Row 
#then append letter to Tray
myfactors_rep1$TrayUL <- NA
for (i in 1:nrow(myfactors_rep1)){
  my_x <- myfactors_rep1[i,8]
  myfactors_rep1[i,13] <- stri_sub(my_x,1,1)
}
myfactors_rep1$TrayUL <- paste(myfactors_rep1$Tray, myfactors_rep1$TrayUL, sep="")

myfactors_rep2$TrayUL <- NA
for (i in 1:nrow(myfactors_rep2)){
  my_x <- myfactors_rep2[i,8]
  myfactors_rep2[i,13] <- stri_sub(my_x,1,1)
}
myfactors_rep2$TrayUL <- paste(myfactors_rep2$Tray, myfactors_rep2$TrayUL, sep="")

myfactors_rep1 <- myfactors_rep1[,c("Exp","Block","Tray","TrayUL","Species","LsGeno","BcGeno","Column","Image","Object")]
myfactors_rep2 <- myfactors_rep2[,c("Exp","Block","Tray","TrayUL","Species","LsGeno","BcGeno","Column","Image","Object")]

#now fix myplants columns
myplants_rep1 <- myplants_rep1[,c("Exp","Block","Image","LsGeno","Species","CHAMBER","GrowTray","IndPlant")]
names(myplants_rep1)[6] <- "Chamber"
myspecies <- myplants_rep1[,c("LsGeno","Species")]
myspecies <- as.data.frame(unique(myspecies))
myplants_rep2 <- merge(myplants_rep2, myspecies, by="LsGeno")
myplants_rep2 <- myplants_rep2[,c("Exp","Block","Image","LsGeno","Species","Chamber","GrowTray","IndPlant")]
myplants_all <- rbind(myplants_rep1, myplants_rep2)

#first add Lesion.Size from mydata onto myfactors for each experiment
#rep1
myfactors_rep1$img.obj <- paste(myfactors_rep1$Image,myfactors_rep1$Object, sep=".")
mydata_rep1$img.obj <- paste(mydata_rep1$Image,mydata_rep1$Object, sep=".")
mydata_rep1 <- mydata_rep1[,c("img.obj","Lesion.Size")]
fullinfo_rep1 <- merge(myfactors_rep1, mydata_rep1, by="img.obj") #removes some rows with missing data, fine
#rep2
myfactors_rep2$img.obj <- paste(myfactors_rep2$Image,myfactors_rep2$Object, sep=".")
mydata_rep2$img.obj <- paste(mydata_rep2$Image,mydata_rep2$Object, sep=".")
mydata_rep2 <- mydata_rep2[,c("img.obj","Lesion.Size")]
fullinfo_rep2 <- merge(myfactors_rep2, mydata_rep2, by="img.obj")
#then add IsolateID from allisolates
#rep1
names(fullinfo_rep1)[8] <- "BcGeno_01"
fullinfo_rep1 <- merge(fullinfo_rep1, allisolates, by="BcGeno_01") #removes control
fullinfo_rep1 <- fullinfo_rep1[,c("Exp","Block","TrayUL", "Species","LsGeno","IsolateID","Column","Lesion.Size", "Image")]
names(fullinfo_rep1)[3] <- "Tray"
#rep2
names(fullinfo_rep2)[8] <- "BcGeno_02"
fullinfo_rep2 <- merge(fullinfo_rep2, allisolates, by="BcGeno_02") #removes control
fullinfo_rep2 <- fullinfo_rep2[,c("Exp","Block","TrayUL","Species","LsGeno","IsolateID","Column","Lesion.Size","Image")]
names(fullinfo_rep2)[3] <- "Tray"

#then combine both experiments
fullinfo_rep1 <- fullinfo_rep1[,c("Exp","Block","Tray","Species","LsGeno","Column","Image","Lesion.Size","IsolateID")]
fullinfo_rep2 <- fullinfo_rep2[,c("Exp","Block","Tray","Species","LsGeno","Column","Image","Lesion.Size","IsolateID")]
names(fullinfo_rep2)[7] <- "imgbad"
fullinfo_rep2$Image <- paste("LsBc",fullinfo_rep2$imgbad, sep="")
fullinfo_rep2 <- fullinfo_rep2[,-c(7)]
fullinfo_all <- rbind(fullinfo_rep1, fullinfo_rep2)

#then add CHAMBER, GrowTray, IndPlant from myplants
#rep1
fullinfo_all$Image.LsGeno <- paste(fullinfo_all$Image, fullinfo_all$LsGeno, sep=".")
myplants_all$Image.LsGeno <- paste(myplants_all$Image, myplants_all$LsGeno, sep=".")
myplants_all <- myplants_all[,c("Image.LsGeno","Chamber","GrowTray","IndPlant")]
fullinfo_all <- merge(fullinfo_all, myplants_all, by="Image.LsGeno")

#then add PlantGeno from mylettuce
fullinfo_all <- merge(fullinfo_all, mylettuce, by="LsGeno")

#then add ruler info and calculate Scale.LS
myruler <- myruler[,c("Image.Name","pixels..cm")]
names(myruler)[1] <- "Image"
names(myruler)[2] <- "pixelsPcm"
fullinfo_all <- merge(fullinfo_all, myruler, by="Image")
fullinfo_all$pixelsPcm2 <- fullinfo_all$pixelsPcm^2
fullinfo_all$Scale.LS <- fullinfo_all$Lesion.Size/fullinfo_all$pixelsPcm2

#then rename to match Celine
#Num_ID <- not my data
#Exp <- Exp
#Rep <- Block
#Flat <- Tray
#Domest  from Species
#PlantGeno from mylettuce$LsGeno matching
#IndPlant from myplants$IndPlant matching
#IsolateID from allisolates$BcGeno matching
#Scale.LS
#Taxon <- Lactuca
#Wi_Do <- Lac_Domest
#Full_key_plant <- Taxon_WiDo_PlantGeno
#Plant_isol <- IndPlant_IsolateID
#Isolate_taxon_key <- IsolateID_Taxon
fullinfo_all$Domest <- "blank"
fullinfo_all$Domest <- ifelse(fullinfo_all$Species == "Lsativa", "D", "W")
hist(table(fullinfo_all$IndPlant))#good!
hist(table(fullinfo_all$Isolate))#good!
fullinfo_all$Taxon <- "Lactuca"
fullinfo_all$Wi_Do <- paste(fullinfo_all$Taxon, fullinfo_all$Species, sep="_")
fullinfo <- fullinfo_all[,c("Exp","Block","Tray","Domest","PlantGeno","IndPlant","IsolateID","Scale.LS","Taxon","Wi_Do")]
names(fullinfo)[2] <- "Rep"
names(fullinfo)[3] <- "Flat"
fullinfo$Full_key_plant <- paste(fullinfo$Wi_Do, fullinfo$PlantGeno, sep="_")
fullinfo$Plant_isol <- paste(fullinfo$IndPlant, fullinfo$IsolateID, sep="_")
fullinfo$Isolate_taxon_key <- paste(fullinfo$IsolateID, fullinfo$Taxon, sep="_")
write.csv(fullinfo, "BcLsGWAS_forCC.csv")
#fullinfo <- read.csv("BcLsGWAS_forCC.csv")
