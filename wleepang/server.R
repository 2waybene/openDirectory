# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#
library(shiny)

shinyServer(function(input, output, session) {

  observeEvent(
    ignoreNULL = TRUE,
    eventExpr = {
      input$Without
    },
    handlerExpr = {
      if (input$Without > 0) {
        # condition prevents handler execution on initial app launch
        withoutPath = choose.dir(default = readDirectoryInput(session, 'Without'),
          caption="Choose a directory...")
        updateDirectoryInput(session, 'Without', value = withoutPath )
      }
      
    }
  )

  
  observeEvent(
    ignoreNULL = TRUE,
    eventExpr = {
      input$With
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
  
  # T-Score calculations tscores()
 # eventReactive(input$goButton,{ 
#    print ("hello world")
 # })
  
  ntext <- eventReactive(input$goButton, {
    #input$With
    "hello world"
  })
  
  
  
  output$nText <- renderText({
    ntext()
   # "hello world"
  })
  
  output$distPlot <- renderPlot({
    # Take a dependency on input$goButton. This will run once initially,
    # because the value changes from NULL to 0.
    input$goButton
    
    # Use isolate() to avoid dependency on input$obs
    dist <- isolate(rnorm(input$obs))
    hist(dist)
  })
  
  
  output$Without = renderText({
    readDirectoryInput(session, 'Without')
  })

  
  output$With = renderText({
    readDirectoryInput(session, 'With')
  })
  
  
  ntext <- eventReactive(input$goButton, {
    #input$With
    paste ("hello world" , withPath, sep =" ")
  })
  
  output$files = renderDataTable({
    files = list.files(readDirectoryInput(session, 'directory'), full.names = T)
    data.frame(name = basename(files), file.info(files))
  })

})
