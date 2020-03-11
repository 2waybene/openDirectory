# https://stackoverflow.com/questions/47719285/display-selected-folder-path-in-shiny

library(shiny)
library(shinyFiles)

# Define UI for application that draws a histogram
ui <- fluidPage( # Application title
  mainPanel(
    shinyDirButton("dir", "Input directory", "Upload"),
    verbatimTextOutput("dir", placeholder = TRUE)  # added a placeholder
  ))

server <- function(input, output) {
  shinyDirChoose(
    input,
    'dir',
    roots = c(home = '~'),
    filetypes = c('', 'txt', 'bigWig', "tsv", "csv", "bw")
  )
  
  dir <- reactive(input$dir)
  output$dir <- renderText({  # use renderText instead of renderPrint
    parseDirPath(c(home = '~'), dir())
  })
  
  
  
  observeEvent(ignoreNULL = TRUE,
               eventExpr = {
                 input$dir
               },
               handlerExpr = {
                 home <- normalizePath("~")
                 datapath <<-
                   file.path(home, paste(unlist(dir()$path[-1]), collapse = .Platform$file.sep))
               })
  
  
}

# Run the application
shinyApp(ui = ui, server = server)

