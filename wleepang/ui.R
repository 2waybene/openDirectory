# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library('shinyDirectoryInput')



shinyUI(fluidPage(
  fluidRow(
    column(1),
    column(
      width = 10,

      # Application title
      titlePanel("Directory Input Demo"),
      
      directoryInput('Without', label = 'EliminationWithoutReplacement', value = '~'),
      verbatimTextOutput('Without', placeholder = TRUE) ,
      
      directoryInput('With',    label = 'EliminationWithReplacement', value = '~') ,
      verbatimTextOutput('With',  placeholder = TRUE) ,
 
      
      
 
      verbatimTextOutput("nText") , 
 
      shinySaveButton("save", "Save file", "Save file as ...", filetype=list(xlsx="txt")),
      
      verbatimTextOutput('save',  placeholder = TRUE) ,
 
 # sliderInput("obs", "Number of observations", 0, 1000, 500),
 
 
      actionButton("goButton", "Calculate",
                   style="font-weight: bold;color: #000000; background-color: #00FF08; border-color: #aea79f"), # Go button
      # div(style="display: inline-block;vertical-align:top; width: 30px;",HTML("<br>")),
      
      
      
      htmlOutput("foo"), # All files created display
 
  
      
 # plotOutput("distPlot")
      
     # tags$h5('Files'),
     #  dataTableOutput('files')
    ),
    column(1)
  )
))
