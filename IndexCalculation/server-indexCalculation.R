#  Rscript --vanilla /ddn/gs1/home/li11/ddnDrive/project2019/SEM/rscripts/calculate_index_streamline_linux_w_arguments.R  
# /ddn/gs1/home/li11/ddnDrive/project2019/SEM/data/new_t_scores_w_lev_03272019.rda 
# /ddn/gs1/home/li11/ddnDrive/project2019/SEM/IPA/ChemDrug_184_results/EliminationWithReplacement/ 
# /ddn/gs1/home/li11/ddnDrive/project2019/SEM/IPA/ChemDrug_184_results/EliminationWithoutReplacement/ 
# /ddn/gs1/home/li11/ddnDrive/project2019/SEM/rscripts/helpScripts/SEM_util.R  
# /ddn/gs1/home/li11/ddnDrive/project2019/SEM/IPA/ChemDrug_184_results/ChemDrug184_index.txt  

# Load T-Scores data
load ("dataSEM/new_t_scores_w_lev_03272019.rda")

# Number of bootstrap runs (ex: 1000)
bootnum <- reactive({  
  input$Without
})
bootChoice <- reactive({  
  input$With
})





print(bootnum)


vals <- reactiveValues()


observeEvent(
  
  ignoreNULL = TRUE,
  eventExpr = {
    input$Without
   # bootnum()
    print (input$Without)
  },
  handlerExpr = {
    print (input$Without)
    if (input$Without > 0) {
      # condition prevents handler execution on initial app launch
      withoutPath = choose.dir(default = readDirectoryInput(session, 'Without'),
                               caption="Choose a directory...")
      updateDirectoryInput(session, 'Without', value = withoutPath )
    }
  } 
)

output$Without = renderText({
  readDirectoryInput(session, 'Without')
})

observeEvent(
  ignoreNULL = TRUE,
  eventExpr = {
    input$With
   # bootChoice ()
  },
  handlerExpr = {
    if (input$With > 0) {
      # condition prevents handler execution on initial app launch
      withPath  = choose.dir(default = readDirectoryInput(session, 'With'),
                             caption="Choose a directory...")
      updateDirectoryInput(session, 'With', value = withPath )
    }
  } 
)

output$With = renderText({
  vals$With  = readDirectoryInput(session, 'With')
})

output$Without = renderText({
  vals$Without = readDirectoryInput(session, 'Without')
})

ntext <- eventReactive(input$goButton, {
  paste ("hello world" ,  vals$W  , "second part", sep =" ")
})


output$nText <- renderText({
  ntext()
  # "hello world"
})