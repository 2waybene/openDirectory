
  # Generate a plot of the data ----
  # Also uses the inputs to build the plot label. Note that the
  # dependencies on the inputs and the data reactive expression are
  # both tracked, and all expressions are called in the sequence
  # implied by the dependency graph.

  # Generate a summary of the data ----
  output$summary <- renderPrint({
    summary(d())
  })
  
