# load ("dataSEM/parsedCellReportDT.rda")
load ("dataSEM/parsedNewDT.rda")
load ("dataSEM/new_t_scores_w_lev.rda")

endoVars <- c(colnames(dat),colnames(NewDT))
exoVars <- c(colnames(dat))

tabPanel("SEM", br(),
        #  fluidRow(
        # column(3, 
        #  selectInput("exo1",label="Choose a exogenous variable", choices=endoVars, selected="GATA2_act_FC13_P01"),
        #  selectInput("exo2",label="Choose a exogenous variable", choices=endoVars, selected="PRG_act_FC13_P01"),
        #  selectInput("endo",label="Choose a endogenous variable", choices=endoVars, selected="SOX17_lev")),
        # column(5,div(style="display: inline-block;vertical-align:top;",verbatimTextOutput("semSummary")))),
        # column(4,
        #  div(style="display: inline-block;vertical-align:top;",imageOutput("semModel")))
    
         
         
        
        tabsetPanel(
          tabPanel("Model", 
                   fluidRow(
                     column(3, 
                            selectInput("exo1",label="Choose a exogenous variable", choices=endoVars, selected="GATA2_act_FC13_P01"),
                            selectInput("exo2",label="Choose a exogenous variable", choices=endoVars, selected="PRG_act_FC13_P01"),
                            selectInput("endo",label="Choose a endogenous variable", choices=endoVars, selected="SOX17_lev")),
                     column(5,div(style="display: inline-block;vertical-align:top;",verbatimTextOutput("semSummary")))),
                   column(4,
                          div(style="display: inline-block;vertical-align:top;",imageOutput("semModel")))
          ),
          tabPanel("SEM Intro",includeMarkdown("instructions/SEMIntro.Rmd"))
          
        )
         
         # column(4,verbatimTextOutput("semSummary")),
         # column(4,imageOutput("semModel"))
         
)



