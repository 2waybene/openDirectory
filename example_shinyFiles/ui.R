library(shiny)
library(shinyFiles)

shinyUI(fluidPage(sidebarLayout(
  
  sidebarPanel(
    shinyDirButton("dir", "Chose directory", "Upload")
  ),
  
  mainPanel(
    h4("output$dir"),
    verbatimTextOutput("dir"), br(),
    h4("Files in that dir"),
    verbatimTextOutput("files")
  )
  
))) 