checkRadio <- reactive({
  input$radio
})
checkRadioGene <- reactive({
  input$radioGene
})
# checkRadioNormal <- reactive({
#   input$radioNormal
# })
checkLow <- reactive({
  input$checkHigh
})


output$sigUploaded <- reactive({
  return(!is.null(input$fileSignature))
})
outputOptions(output, 'sigUploaded', suspendWhenHidden=FALSE)

output$arrayUploaded <- reactive({
  return(!is.null(input$fileArray))
})
outputOptions(output, 'arrayUploaded', suspendWhenHidden=FALSE)


output$Sig <- renderDataTable({ 
  req(inFileS <- input$fileSignature)
  Signatures <- read_excel(inFileS$datapath)
  Signatures <- as.data.frame(Signatures)
  globalValues$VanillaSig <- Signatures
  datatable(Signatures,rownames = FALSE,
            options = list(scroller = TRUE,scrollX = T,paging=FALSE,dom='t'))  # options = list(pageLength = -1,dom = 't') 
})

output$Array <- renderDataTable({ 
  req(inFileA <- input$fileArray)
  HumanArray <- read_excel(inFileA$datapath)
  HumanArray <- as.data.frame(HumanArray)
  globalValues$VanillaArray <- HumanArray
  datatable(HumanArray,rownames = FALSE,
            options = list(scroller = TRUE,scrollX = T,paging=TRUE,pageLength =5,bLengthChange=0, bFilter=0))  # options = list(pageLength = -1,dom = 't') 
})

tscores <- eventReactive(input$goButton,{   
  req(inFileS <- input$fileSignature)
  req(inFileA <- input$fileArray)
  
  # Signatures <- read_excel(inFileS$datapath)
  # HumanArray <- read_excel(inFileA$datapath)
  # Signatures <- as.data.frame(Signatures)
  # HumanArray <- as.data.frame(HumanArray)
  Signatures <- as.data.frame(globalValues$VanillaSig) 
  HumanArray <- as.data.frame(globalValues$VanillaArray)
  # if(checkRadioNormal()==2){
    HumanArray[3:ncol(HumanArray)] <- t(apply(HumanArray[3:ncol(HumanArray)],1,function(y)y-median(y)))
  # }

  
  dup <- duplicated(HumanArray[,1])
  if (any(dup)){
    HumanArray$Stdev <- apply(HumanArray[3:ncol(HumanArray)],1,sd)
    HumanArray <- HumanArray[order(HumanArray$Stdev, decreasing=TRUE),]
    HumanArray <- HumanArray[!duplicated(HumanArray[,1]),]
    HumanArray <- HumanArray[1:ncol(HumanArray)-1]
    
  }
  
  
  if(checkRadioGene()==1){
    x <- vector(mode="character", length=nrow(Signatures))
    for(i in 1:length(x)){
      a <- which(Reference$Mouse==Signatures[i,1])
      if (identical(a, integer(0))){
        x[i]<-"?"
      }
      else{
        x[i]=Reference[a,2]
      }
    }
    
    Signatures$Human <- as.character(x)
    Signatures <- Signatures[c(3,2)]
    print(Signatures)
  }
  else{
    colnames(Signatures)[1]<-"Human"
  }
  
  Signatures$Human[Signatures$Human == "?"] <- NA
  
  globalValues$MasterSig <- Signatures
  globalValues$MasterArray <- HumanArray
  
  SigInfo <- as.data.frame(table(Signatures$Human)) # frequency table
  colnames(SigInfo)[1]<-"Human"
  
  # extract signatures of relevants
  a <- Signatures[!duplicated(Signatures[,c('Human')]),]
  a<-na.omit(a)
  a<-a[order(a$Human),]
  SigInfo$Signature <- a$Signature
  
  colnames(HumanArray)[1:2]<-c("GENE_SYMBOL","Probe")
  
  #overlapNotCase <- intersect(HumanArray$GENE_SYMBOL,SigInfo$Human)
  
  HumanArray$GENE_SYMBOL <- toupper(HumanArray$GENE_SYMBOL) # not case sensitive
  SigInfo$Human <- toupper(SigInfo$Human)
  
  overlap <- intersect(HumanArray$GENE_SYMBOL,SigInfo$Human)
  SigInfo <- SigInfo[SigInfo$Human %in% overlap,] # get rid of non-overlaps
  HumanArray <- HumanArray[HumanArray$GENE_SYMBOL %in% overlap,]
  HumanArray<-HumanArray[order(HumanArray$GENE_SYMBOL),]
  final <- merge(SigInfo, HumanArray, by.x="Human", by.y="GENE_SYMBOL")
  final[c(5:length(final))] <- lapply(final[c(5:length(final))], as.numeric)
  
  HighLow <- split(final, final$Signature)
  High <- HighLow$High
  Low <- HighLow$Low
  # High <- High[order(-High$Freq),]
  # Low <- Low[order(-Low$Freq),]

  TScores <- matrix(0,nrow=3,ncol=length(High)-5+1)
  for(i in 1:dim(TScores)[2]){
    TScores[1,i]<- colnames(High)[i+4]
    TScores[2,i]<- t.test(High[i+4],Low[i+4], alternative="two.sided", paired =FALSE, var.equal=TRUE)$p.value
    TScores[3,i]<- t.test(High[i+4],Low[i+4], alternative="two.sided", paired =FALSE, var.equal=TRUE)$statistic
  }
  TScores <- as.data.frame(t(as.data.frame(TScores)))
  TScores[,2] <- as.numeric(as.character(TScores[,2]))
  TScores[,3] <- as.numeric(as.character(TScores[,3]))
  #TScores <- t(as.data.frame(TScores))
  colnames(TScores) <- c("Variable","p-value", "T-score")  # names(eFile)[1]
  TScores
  
})

output$tTable <- renderDataTable({ 
  req(tscores())
  a<-tscores()
  a[2:3]<-signif(a[2:3],7)
  datatable(a,rownames = FALSE)  # options = list(pageLength = -1,dom = 't') 
})

output$downloadData <- downloadHandler(
  filename = function() {
    paste("tscores", ".csv", sep = "")
  },
  content = function(file) {
    write.csv(tscores(), file, row.names = FALSE)
  }
)
