library(shiny)
library(shinyFiles)

ui <- fluidPage( # Application title
  mainPanel(
    shinyDirButton("dir", "Input directory", "Upload"),
    verbatimTextOutput("dir", placeholder = TRUE) , 
    
    label("EliminationWithoutReplacement directory"),
    label("Choose folder", class="btn btn-primary",
                        tags$input(id = "Without", webkitdirectory = TRUE, type = "file", style="display: none;", onchange="pressed()"))),
    verbatimTextOutput("dir", placeholder = TRUE) ,
    
    tags$div(tags$label("EliminationWithReplacement directory")),
    tags$div(tags$label("Choose folder", class="btn btn-primary",
                        tags$input(id = "With", webkitdirectory = TRUE, type = "file", style="display: none;", onchange="pressed()"))),
    verbatimTextOutput("dir", placeholder = TRUE) ,
    
    shinySaveButton("save", "Save file", "Save file as ...", filetype=list(xlsx="txt")),
    
    #      tags$label("No folder choosen", id = "noFile"),
    tags$div(id="fileIn_progress", class="progress progress-striped active shiny-file-input-progress",
             tags$div(class="progress-bar")
    ),
    
    actionButton("goButton2", "Calculate",
                 style="font-weight: bold;color: #000000; background-color: #00FF08; border-color: #aea79f"), # Go button
    # div(style="display: inline-block;vertical-align:top; width: 30px;",HTML("<br>")),
    
    htmlOutput("foo"), # All files created display
  )


server <- function(input, output) {
  shinyDirChoose(
    input,
    'dir',
    roots = c(home = '~'),
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
}


# Run the application
shinyApp(ui = ui, server = server)
