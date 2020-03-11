#UI
library(shiny)
ui <- fluidPage(
  actionButton("goButton","Choose folder"),
  textOutput("session"))


#server 
library(shiny)

server <- function(input, output, session )
  {
  
  observe({
    if(input$goButton > 0){
      output$session <- renderText(function(){
        list.files(choose.dir())})
    }
    
    
  })
  
}


shinyApp(ui, server)


