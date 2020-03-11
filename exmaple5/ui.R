#UI
library(shiny)
ui <- fluidPage(
  actionButton("goButton","Choose folder"),
  textOutput("session"))

