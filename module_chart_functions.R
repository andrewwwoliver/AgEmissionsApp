# Function to render line charts
render_line_chart <- function(chart_id, chart_data, chart_type, input, output) {
  # Create reactive for the first column name of the data
  column_name <- reactive({ names(chart_data())[1] })
  
  # Create reactive for the chart title
  title <- reactive({
    paste(chart_type, "in Agriculture,", min(input[[paste0("year_", chart_id)]]), "to", max(input[[paste0("year_", chart_id)]]))
  })
  
  # Create reactive for the y-axis title based on chart type
  yAxisTitle <- reactive({
    switch(chart_type,
           "Total Emissions" = "Total Emissions (MtCO2e)",
           "Subsector Emissions" = "Emissions by Subsector (MtCO2e)",
           "Gas Emissions" = "Emissions by Gas (MtCO2e)")
  })
  
  # Call the server function for the line chart module
  lineChartServer(chart_id, chart_data, column_name, title, yAxisTitle)
}

# Function to handle variable select and button events
handle_variable_select_and_buttons <- function(id_prefix, variables, input, output, session) {
  # Render the checkbox group for variable selection
  output[[paste0("variable_select_", id_prefix)]] <- renderUI({
    checkboxGroupInput(paste0("variables_", id_prefix), "Choose variables to add to chart", choices = variables(), selected = variables())
  })
  
  # Observe event for 'Select All' button
  observeEvent(input[[paste0("select_all_button_", id_prefix)]], {
    updateCheckboxGroupInput(session, paste0("variables_", id_prefix), selected = variables())
  })
  
  # Observe event for 'Deselect All' button
  observeEvent(input[[paste0("deselect_all_button_", id_prefix)]], {
    updateCheckboxGroupInput(session, paste0("variables_", id_prefix), selected = character(0))
  })
}
