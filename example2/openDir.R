library(shiny)
library(shinyFiles)
library(xlsx)

ui <- shinyUI(fluidPage(
  
  titlePanel("Example"),
  shinySaveButton("save", "Save file", "Save file as ...", filetype=list(xlsx="xlsx"))
 
))

server <- shinyServer(function(input, output, session) {
  
  
  
  observe({
    volumes <- c("UserFolder"="D:/Data")
    shinyFileSave(input, "save", roots=volumes, session=session)
    fileinfo <- parseSavePath(volumes, input$save)
    data <- data.frame(a=c(1,2))
    if (nrow(fileinfo) > 0) {
      write.xlsx(data, as.character(fileinfo$datapath))
    }
  })
})

shinyApp(ui = ui, server = server)