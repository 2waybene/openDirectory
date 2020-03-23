options(warn=-1)
options(shiny.maxRequestSize=300*1024^2)
source("helpers.R")

function(input, output) {
  globalValues <- reactiveValues(
  MasterSig=data.frame(),
  MasterArray=data.frame(),
  VanillaSig=data.frame(),
  VanillaArray=data.frame(),
  subset=data.frame(),
  directory=character(),
  fileNames=character()
  )
  #globalValues$directory=getwd()
  source("server-Tscore.R",local = TRUE)
  source("server-bootstrap.R",local = TRUE)
  source("server-sem.R",local = TRUE)
  
}