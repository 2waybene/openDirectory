tabPanel("IndexCalculation",
         fluidRow(
           
           #<button id="inputId" type="button" class="shinyDirectories btn-default" data-title="title">label</button>
           shinyDirButton("Without", "EliminationWithoutReplacement directory", "Upload"),   
           
           verbatimTextOutput("dir", placeholder = TRUE) ,
           
           shinyDirButton("With", "EliminationWithReplacement directory", "Upload"),  
           shinyDirButton("Output", "Output directory", "Upload"),  
          # div(style="display: inline-block;vertical-align:top; width: 275px;",fileInput("fileSubset","Upload the subset file")), # Subset file input
        
        
          # div(style="display: inline-block;vertical-align:top; width: 30px;",HTML("<br>")),
      
           
           actionButton("goButton2", "Calculate",
                        style="font-weight: bold;color: #000000; background-color: #00FF08; border-color: #aea79f"), # Go button
          # div(style="display: inline-block;vertical-align:top; width: 30px;",HTML("<br>")),
         
           htmlOutput("foo") # All files created display

         )
)