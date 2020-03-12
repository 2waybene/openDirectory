# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#
library(shiny)


shinyServer(function(input, output, session) {
  
  vals <- reactiveValues()
  
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
  
  output$Without = renderText({
    readDirectoryInput(session, 'Without')
  })
  
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
  
 # results <- reactiveVal("")
 
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
  


})
