#UI
library(shiny)

shinyServer(function(input, output, session) {
  
  observe({
    if(input$goButton > 0){
      output$session <- renderText(function(){
        list.files(choose.dir())})
    }
    
    
  })
  
})

