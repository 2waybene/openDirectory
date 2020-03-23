library(readxl)
library(tidyr)
library(stringr)
#setwd("C:/Users/dayk2/Desktop/Bootstrap/CSVs")
MasterSig <- read_excel("Human Sig.xlsx")
HumanArray <- read_excel("Human Array.xlsx")
colnames(HumanArray)[1]<-"Gene"
names <- c("ATF4","beta-estradiol","EGFR", "ERN1","FOXO3","HOXA10","MITF","progesterone","PTEN","RUNX3","TGFBR1","Vegf","XBP1")
targets <- c(34,289,73,31,62,39,27,124,83,20,14,72,45)

for (reg in 1:13){
  cName <- names[reg]
  targetNumber <- targets[reg]
  
  TScores <- matrix(0,nrow=1000,ncol=length(HumanArray)-1)
  for(i in 1:nrow(TScores)){
    TScores[i,1] <- paste0("Random_",cName,"_",targetNumber,"_",str_pad(i, 4, pad = "0")) #Random_34_0001
    
    set.seed(1+i*100+reg)
    eliminateRandoms <- sample.int(nrow(MasterSig),targetNumber)
    
    subSet <- MasterSig[-eliminateRandoms,] 
    
    
    a <-subSet[!duplicated(subSet[,1]),] 
    colnames(a)[1]<-"Human"
    a$Human[a$Human == "?"] <- NA
    a<-na.omit(a)
    a<-a[order(a$Human),]
    
    a$Human <- toupper(a$Human)
    HumanArray$Gene <- toupper(HumanArray$Gene)
    
    overlap <- intersect(a$Human,HumanArray$Gene) 
    a <- a[a$Human %in% overlap,] # get rid of non-overlaps
    ArrayDummy <- HumanArray[HumanArray$Gene %in% overlap,]
    ArrayDummy<-ArrayDummy[order(ArrayDummy$Gene),]
    
    final <- merge(a, ArrayDummy, by.x="Human", by.y="Gene")
    final[4:length(final)] <- lapply(final[4:length(final)], as.numeric) 
    
    HighLow <- split(final, final$Signature)
    High <- HighLow$High
    Low <- HighLow$Low
    
    for(j in 1:(ncol(TScores)-1)){
      TScores[i,j+1]<- t.test(High[j+3],Low[j+3], alternative="two.sided", paired =FALSE, var.equal=TRUE)$statistic
    }
    
  }
  
  colnames(TScores)[2:ncol(TScores)] <- colnames(final)[4:ncol(final)]
  colnames(TScores)[1] <- "Run"
  filePath <- paste0(cName,"_",targetNumber,".csv")
  write.csv(TScores,filePath,row.names=F)
  
}

