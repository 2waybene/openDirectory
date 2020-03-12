library(shiny)
library(shinyFiles)

shinyServer(function(input, output, session) {
  
  # dir
  shinyDirChoose(input, 'dir', roots = c(home = '~'), filetypes = c('', 'txt'))
  
  dir <- reactive(input$dir)
  output$dir <- renderPrint(dir())
  
  # path
  path <- reactive({
    home <- normalizePath("~")
    file.path(home, paste(unlist(dir()$path[-1]), collapse = .Platform$file.sep))
  })
  
  # files
  output$files <- renderPrint(list.files(path()))
}) 

