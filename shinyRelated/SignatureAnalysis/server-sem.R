# load ("dataSEM/parsedCellReportDT.rda")
load ("dataSEM/parsedNewDT.rda")
load ("dataSEM/new_t_scores_w_lev.rda")
Combined <- as.data.frame(c(dat,NewDT))
img <- readPNG("www/SEMBlank2.png")
img <- as.raster(img)

chosenExo1 <- reactive({    
  input$exo1
})

chosenExo2 <- reactive({    
  input$exo2
})

chosenEndo <- reactive({    
  input$endo
})

output$semSummary <- renderPrint({
  mod <- paste0(chosenEndo()," ~ ",chosenExo1()," + ", chosenExo2())
  mod.fit <<- sem(mod, data=Combined)
  summary(mod.fit)
})

output$semModel <- renderImage ({
  exo1endo <- parameterestimates(mod.fit)[1,7] # pvalue
  exo2endo <- parameterestimates(mod.fit)[2,7]
  # endoCov <- cov(Combined[chosenExo1()],Combined[chosenExo2()])
  endosCor <- as.numeric(cor.test(Combined[,chosenExo1()],Combined[,chosenExo2()])$estimate)
  endosPvalue <- cor.test(Combined[,chosenExo1()],Combined[,chosenExo2()])$p.value
  
  tmpdir <- tempdir()
  filePath <- paste0(tmpdir,"/myplot.png")
  png(file=filePath, bg="transparent",width=800, height=800,res=1000) # , width=100, height=100, res=300
  par(mar=rep(0, 4),bg = 'white')
  plot(1:9.9,type='n',axes=FALSE,ann=FALSE)
  rasterImage(img, 1, 1, 9, 9)
  text(2.55,7.1,chosenExo1(),cex=.1)
  text(7.45,7.1,chosenExo2(),cex=.1)
  text(5,2.25,chosenEndo(),cex=.1)
  text(3,4.5,paste0("p = ",signif(exo1endo)),cex=.1)
  text(7.5,4.5,paste0("p = ",signif(exo2endo)),cex=.1)
  text(5,9.1,paste0("r = ",signif(endosCor),", (p = ",signif(endosPvalue),")"),cex=.1)
  dev.off()
  
  list(
    src = filePath,
    contentType = "image/png")
  
},deleteFile = FALSE)