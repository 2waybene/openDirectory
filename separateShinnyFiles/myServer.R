myserver <- function(input,output,session){
  output$mychoice <- renderText(
    input$select
  )
}
