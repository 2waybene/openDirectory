ui <- fluidPage(
  
  # Application title
  mainPanel(
    shinyDirButton("dir", "Input directory", "Upload"),
    #conditionalPanel(
    #condition = "???",
    verbatimTextOutput('dir')
    #)
  )
)

server <- function(input, output) {
  
  shinyDirChoose(input, 'dir', roots = c(home = '~'), filetypes = c('', 'txt','bigWig',"tsv","csv","bw"))
  
  dir <- reactive(input$dir)
  output$dir <- renderPrint({parseDirPath(c(home = '~'), dir())})
  
  observeEvent(
    ignoreNULL = TRUE,
    eventExpr = {
      input$dir
    },
    handlerExpr = {
      home <- normalizePath("~")
      datapath <<- file.path(home, paste(unlist(dir()$path[-1]), collapse = .Platform$file.sep))
    }
  )
}

# Run the application 
shinyApp(ui = ui, server = server)