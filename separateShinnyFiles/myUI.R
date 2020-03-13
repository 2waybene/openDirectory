source('Tabs.R')
myUI <- shinyUI({
  fluidPage(
    tabsetPanel(
      Tab1,
      Tab2
    )
  )
})