
tabPanel("IndexCalculation",
     fluidRow(
         wellPanel(
         tags$div(class="form-group shiny-input-container", 
    #  tags$div(tags$label("EliminationWithoutReplacement directory")),
    #  tags$div(tags$label("Choose folder", class="btn btn-primary",
    #  tags$input(id = "Without", webkitdirectory = TRUE, type = "file", style="display: none;", onchange="pressed()"))),
       
          tags$div(directoryInput('Without', label = 'EliminationWithoutReplacement', value = '~')),
          verbatimTextOutput("Without", placeholder = TRUE) ,
                    
    # tags$div(tags$label("EliminationWithReplacement directory")),
    # tags$div(tags$label("Choose folder", class="btn btn-primary",
    # tags$input(id = "With", webkitdirectory = TRUE, type = "file", style="display: none;", onchange="pressed()"))),
                
          directoryInput('With',    label = 'EliminationWithReplacement', value = '~') ,
          verbatimTextOutput("With", placeholder = TRUE) ,
                      
          shinySaveButton("save", "Save file", "Save file as ...", filetype=list(xlsx="txt")),
            
    # tags$label("No folder choosen", id = "noFile"),
          tags$div(id="fileIn_progress", class="progress progress-striped active shiny-file-input-progress",
                        tags$div(class="progress-bar")),
                    
          actionButton("goButton2", "Calculate",
          style="font-weight: bold;color: #000000; background-color: #00FF08; border-color: #aea79f"), # Go button
                    # div(style="display: inline-block;vertical-align:top; width: 30px;",HTML("<br>")),
                    
          htmlOutput("foo") # All files created display
     ),
     verbatimTextOutput("results")
   )
  )
)


#  Rscript --vanilla /ddn/gs1/home/li11/ddnDrive/project2019/SEM/rscripts/calculate_index_streamline_linux_w_arguments.R  
# /ddn/gs1/home/li11/ddnDrive/project2019/SEM/data/new_t_scores_w_lev_03272019.rda 
# /ddn/gs1/home/li11/ddnDrive/project2019/SEM/IPA/ChemDrug_184_results/EliminationWithReplacement/ 
# /ddn/gs1/home/li11/ddnDrive/project2019/SEM/IPA/ChemDrug_184_results/EliminationWithoutReplacement/ 
# /ddn/gs1/home/li11/ddnDrive/project2019/SEM/rscripts/helpScripts/SEM_util.R  
# /ddn/gs1/home/li11/ddnDrive/project2019/SEM/IPA/ChemDrug_184_results/ChemDrug184_index.txt  

