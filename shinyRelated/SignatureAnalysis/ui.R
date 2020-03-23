options(warn=-1)
source("helpers.R")

fluidPage(
           
  titlePanel("Signature Analysis"),
  
  
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(width=4,
      div(style="display: inline-block;vertical-align:top; width: 275px;",fileInput("fileSignature","Upload the signature file")),
      div(style="display: inline-block;vertical-align:top; width: 10px;",HTML("<br>")),
      div(style="display: inline-block;vertical-align:top; width: 100px;",radioButtons("radioGene", label="Gene Type",choices = list("Mouse" = 1, "Human" = 2),selected = 1)),
      br(),
      conditionalPanel("output.sigUploaded",div(style = 'height: 200px;margin: auto; overflow-y: scroll',DT::dataTableOutput("Sig",width = "100%"))),
      br(),
      div(style="display: inline-block;vertical-align:top; width: 275px;",fileInput("fileArray","Upload the human microarray file")),
      
      # div(style="display: inline-block;vertical-align:middle; width: 180px;",
      #     radioButtons("radioNormal", label="Normalize (median-shift)",
      #                  choices = list("Already normalized" = 1, "Normalize data" = 2),selected = 1)),
      br(),
      conditionalPanel("output.arrayUploaded",div(style = 'overflow-x: scroll',DT::dataTableOutput("Array",width = "100%"))),
      br(),
      actionButton("goButton", "Go!",
                   style="font-weight: bold; color: #00FF08; background-color: #aea79f; border-color: #aea79f")
      
      
    
  ),
  tagList(
  mainPanel(
  navbarPage(
    
    theme = "bootstrap.min.cerulean.css",
    title = "Tabs:",
      
      source("ui-Tscore.R",local=TRUE)$value,
      source("ui-bootstrap.R",local=TRUE)$value,
      source("ui-sem.R",local=TRUE)$value,
      source("ui-instructions.R",local=TRUE)$value
    
      
    )
  ) #end navbarpage
) #end taglist
)
)
