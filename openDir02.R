library(shiny)
library(shinyFiles)



ui <- shinyUI(bootstrapPage(
  shinyDirButton('folder', 'Folder select', 'Please select a folder'),
  verbatimTextOutput("dir", placeholder = TRUE) 
  
))

server <- shinyServer(function(input, output) {
#  shinyDirChoose(input, 'folder', roots=c(wd='x:/'), filetypes=c('', 'txt'))
  
  shinyDirChoose(
      input,
    'folder',
 #   roots = c(home = '~'),
    roots=c(wd='x:/'),
    filetypes = c('', 'txt', 'bigWig', "tsv", "csv", "bw")
  )
  
  global <- reactiveValues(datapath = getwd())
  
  dir <- reactive(input$dir)
  
  output$dir <- renderText({
    global$datapath
  })
  
  observeEvent(ignoreNULL = TRUE,
               eventExpr = {
                 input$dir
               },
               handlerExpr = {
                 if (!"path" %in% names(dir())) return()
                 home <- normalizePath("~")
                 global$datapath <-
                   file.path(home, paste(unlist(dir()$path[-1]), collapse = .Platform$file.sep))
               })
  
  
})
runApp(list(
  ui=ui,
  server=server
))
