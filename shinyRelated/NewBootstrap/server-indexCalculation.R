# Load T-Scores data
load ("dataSEM/new_t_scores_w_lev_03272019.rda")

shinyDirChoose(
  input,
  'Without',
  roots = c(home = '~'),
  filetypes = c('', 'txt', 'bigWig', "tsv", "csv", "bw")
)



global <- reactiveValues(datapath = getwd())

dir <- reactive(input$Without)

output$dir <- renderText({
  global$datapath
})

observeEvent(ignoreNULL = TRUE,
             eventExpr = {
               input$Without
             },
             handlerExpr = {
               if (!"path" %in% names(dir())) return()
               home <- normalizePath("~")
               global$datapath <-
                 file.path(home, paste(unlist(dir()$path[-1]), collapse = .Platform$file.sep))
             })