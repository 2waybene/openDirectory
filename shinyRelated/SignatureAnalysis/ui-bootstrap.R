tabPanel("Bootstrap",
         fluidRow(
           
           div(style="display: inline-block;vertical-align:top; width: 275px;",fileInput("fileSubset","Upload the subset file")),
           div(style="display: inline-block;vertical-align:top; width: 30px;",HTML("<br>")),
           div(style="display: inline-block;vertical-align:middle; width: 130px;",numericInput("bootNum","Enter number of random bootstraps",value=1000)),
           div(style="display: inline-block;vertical-align:middle; width: 30px;",HTML("<br>")),
           actionButton("goButton2", "Go!",
                        style="font-weight: bold;color: #000000; background-color: #00FF08; border-color: #aea79f"),
           div(style="display: inline-block;vertical-align:top; width: 30px;",HTML("<br>")),
           downloadButton("bootdownload", "Download Zip",
                          style="font-weight: bold;color: #000000; background-color: #F17F2B; border-color: #aea79f")
           # column(3,wellPanel(
           #   fileInput("fileSubset","Upload the subset file")
           # )
           # ),
           # column(3,wellPanel(
           #   numericInput("bootNum","Enter number of random bootstraps",value=1000)
           # )
           # )
           # ,
           # div(style="display: inline-block;vertical-align:top; width: 20px;",actionButton("goButton2", "Go!",
           #                                                                                 style="color: #fff; background-color: #CD0000; border-color: #9E0000")),
           # div(style="display: inline-block;vertical-align:top; width: 20px;",HTML("<br>")),
           # div(style="display: inline-block;vertical-align:top; width: 0px;",downloadButton("bootdownload", "Download Zip"
           # )
           # )
           ,
           htmlOutput("foo"),
           div(style = 'margin: auto',DT::dataTableOutput("Subset",width = "100%"))
           # DT::dataTableOutput("Subset",width = "100%")
         )
)