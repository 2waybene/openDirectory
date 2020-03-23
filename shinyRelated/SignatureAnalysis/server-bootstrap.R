bootnum <- reactive({
  input$bootNum
})

values <- reactiveValues(
  a=vector()
)

output$Subset <- renderDataTable({ 
  req(inFileSS <- input$fileSubset)
  subset <- read_excel(inFileSS$datapath)
  subset <- as.data.frame(subset)
  globalValues$subset <- subset
  datatable(subset,rownames = FALSE,
            options = list(scroller = TRUE,scrollX = T,paging=TRUE,pageLength =5,bLengthChange=0, bFilter=0))  # options = list(pageLength = -1,dom = 't') 
})


fs <- eventReactive(input$goButton2, {
  req(inFileSS <- input$fileSubset)
  withProgress(message = 'Calculating T-Scores',value=0,{
  # subset <- read_excel(inFileSS$datapath)
  # subset <- as.data.frame(subset)
    subset <- as.data.frame(globalValues$subset)
  
  req(MasterSig <- globalValues$MasterSig)
#  colnames(MasterSig)[1] <- "Gene"
  req(MasterArray <- globalValues$MasterArray)
#  colnames(MasterArray)[1]<-"Gene"
  req(inFileS <- input$fileSignature)
  req(inFileA <- input$fileArray)
  # MasterSig <- read_excel(inFileS$datapath)
  # MasterArray <- read_excel(inFileA$datapath)
  # MasterSig <- as.data.frame(MasterSig)
  # MasterArray <- as.data.frame(MasterArray)
  
  colnames(MasterSig)[1] <- "Gene"
  colnames(MasterArray)[1]<-"Gene"
  
  files <- c()
  tmpdir <- tempdir()
  #print(tmpdir)
  #setwd(tempdir())
  
  
  print(system.time({
  for (reg in 1:nrow(subset)){
    incProgress(1/(nrow(subset)+1),detail = paste(reg-1,"out of",nrow(subset),"done"))
    
    cName <- subset[reg,1]
    stringVec <- unlist(strsplit(subset[reg,5], ","))
    stringVec <- gsub(" ", "", stringVec,fixed=TRUE)
    Removed <- MasterSig[!MasterSig$Gene %in% stringVec,]
    
    TScores1 <- matrix(0,nrow=1,ncol=length(MasterArray)-2)
    
    a <-Removed[!duplicated(Removed[,1]),]
    colnames(a)[1]<-"Human"
    a$Human[a$Human == "?"] <- NA
    a<-na.omit(a)
    a<-a[order(a$Human),]
    
    a$Human <- toupper(a$Human)
    MasterArray$Gene <- toupper(MasterArray$Gene)
    
    overlap <- intersect(a$Human,MasterArray$Gene)
    a <- a[a$Human %in% overlap,] # get rid of non-overlaps
    ArrayDummy <- MasterArray[MasterArray$Gene %in% overlap,]
    ArrayDummy<-ArrayDummy[order(ArrayDummy$Gene),]
    
    final <- merge(a, ArrayDummy, by.x="Human", by.y="Gene")
    final[4:length(final)] <- lapply(final[4:length(final)], as.numeric)
    
    HighLow <- split(final, final$Signature)
    High <- HighLow$High
    Low <- HighLow$Low
    
    for(j in 1:ncol(TScores1)){
      TScores1[1,j]<- t.test(High[j+3],Low[j+3], alternative="two.sided", paired =FALSE, var.equal=TRUE)$statistic
    }
    colnames(TScores1) <- colnames(final)[4:ncol(final)]
    filePath <- paste0(tmpdir,"/",cName,".csv")
    files <-c(files,filePath)
    write.csv(TScores1,filePath,row.names=F)
    
    
    
    targetNumber <- length(stringVec)
    TScores <- FBM(as.numeric(bootnum()),length(MasterArray)-1)
    numCores <- detectCores()/2
    cl <<- parallel::makeCluster(numCores)
    on.exit(stopCluster(cl))
    on.exit(stopImplicitCluster())
    on.exit(registerDoSEQ())
    doParallel::registerDoParallel(cl)
    
    tmp3 <- foreach(i = 1:nrow(TScores), .combine = 'c') %dopar% {
      # TScores[i,1] <- paste0("Random_",cName,"_",targetNumber,"_",str_pad(i, 4, pad = "0")) #Random_34_0001
      
      set.seed(1+i*100+reg)
      eliminateRandoms <- sample.int(nrow(MasterSig),targetNumber)
      
      subSet <- MasterSig[-eliminateRandoms,] 
      
      
      a <-subSet[!duplicated(subSet[,1]),] 
      colnames(a)[1]<-"Human"
      a$Human[a$Human == "?"] <- NA
      a<-na.omit(a)
      a<-a[order(a$Human),]
      
      a$Human <- toupper(a$Human)
      MasterArray$Gene <- toupper(MasterArray$Gene)
      
      overlap <- intersect(a$Human,MasterArray$Gene) 
      a <- a[a$Human %in% overlap,] # get rid of non-overlaps
      ArrayDummy <- MasterArray[MasterArray$Gene %in% overlap,]
      ArrayDummy<-ArrayDummy[order(ArrayDummy$Gene),]
      
      final <- merge(a, ArrayDummy, by.x="Human", by.y="Gene")
      final[4:length(final)] <- lapply(final[4:length(final)], as.numeric) 
      
      HighLow <- split(final, final$Signature)
      High <- HighLow$High
      Low <- HighLow$Low
      
      for(j in 1:(ncol(TScores)-1)){
        TScores[i,j+1]<- t.test(High[j+3],Low[j+3], alternative="two.sided", paired =FALSE, var.equal=TRUE)$statistic
      }
      NULL
    }
    # parallel::stopCluster(cl)
    # registerDoSEQ()
    # invisible(gc); remove(nCores); remove(nThreads); remove(cluster); 
    
    stopCluster(cl)  ## Modify by JYL, 10/23/19
    ## to return CPUs back to the server  
    
    TScores <- TScores[]
    
    TScores[,1]<-sapply(1:nrow(TScores),function(i) paste0("Random_",cName,"_",targetNumber,"_",str_pad(i, 4, pad = "0")))
    
    
    colnames(TScores)[2:ncol(TScores)] <- colnames(final)[4:ncol(final)]
    colnames(TScores)[1] <- "Run"
    #csvName <- paste0("Random_",cName,"_",targetNumber,".csv") #
    #filePath <- paste0(tmpdir,"/",csvName) #
    filePath <- paste0(tmpdir,"/Random_",cName,"_",targetNumber,".csv")
    files <-c(files,filePath)
    write.csv(TScores,filePath,row.names=F)
    #write.csv(TScores,csvName,row.names=F) #
    
  }
  })) #System.time  
    
  globalValues$fileNames <- files
  incProgress(1/(nrow(subset)+1),detail=paste(reg-1,"out of",nrow(subset),"done"))
  }) # withprogress

  # zip(paste0(tmpdir,"Run.zip"), files)
  # send.mail(from="kevindaymath@gmail.com", to="kevindaymath@gmail.com", subject = "A", attach.files = paste0(tmpdir,"Run.zip"))
  files
})

output$foo <- renderText({
  paths <- paste0(fs(),'<br/>')
  paths <- paste(paths,collapse = '')
  HTML(paste0("<b>Click <font color=\"#ff6600\">Download Zip</font></b><br/><u>Calculated files:</u><br/>",paths)
    )
    
  })

output$bootdownload <- downloadHandler(
  filename = function() {
    paste("output", "zip", sep=".")
  },
  content = function(fname){
    zip(zipfile=fname,files=fs())
  }
  ,
  contentType = "application/zip"
)
