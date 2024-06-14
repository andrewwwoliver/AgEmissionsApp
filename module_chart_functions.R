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

# Function to render area charts
render_area_chart <- function(chart_id, chart_data, chart_type, input, output) {
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
  
  # Call the server function for the area chart module
  areaChartServer(chart_id, chart_data, column_name, title, yAxisTitle)
}

# Function to handle variable select and button events
handle_variable_select_and_buttons <- function(id_prefix, variables, input, output, session) {
  # Filter out "Total" variable
  selected_variables <- reactive({
    vars <- variables()
    vars[vars != "Total"]
  })
  
  # Render the checkbox group for variable selection
  output[[paste0("variable_select_", id_prefix)]] <- renderUI({
    checkboxGroupInput(
      paste0("variables_", id_prefix), 
      "Choose variables to add to chart", 
      choices = variables(), 
      selected = selected_variables()
    )
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


# Function to render data tables
render_data_table <- function(table_id, chart_data, output) {
  output[[table_id]] <- renderDataTable({
    data <- chart_data()  # Get the reactive chart data
    data$Year <- as.character(data$Year)  # Convert Year to character
    first_column_name <- names(data)[1]  # Get the first column name
    # Pivot data to wide format
    data <- pivot_wider(data, names_from = !!sym(first_column_name), values_from = Value)
    # Format numeric columns
    data <- data %>% mutate(across(where(is.numeric), ~ formatC(.x, format = "f", digits = 2)))
    as_tibble(data)  # Convert to tibble
  })
}

# Function to handle data download
handle_data_download <- function(download_id, chart_type, chart_data, input, output) {
  output[[download_id]] <- downloadHandler(
    filename = function() {
      paste("Agricultural Emissions Data -", chart_type, min(input[[paste0("year_", download_id)]]), "to", max(input[[paste0("year_", download_id)]]), ".csv", sep = " ")
    },
    content = function(file) { 
      data <- chart_data()  # Get the reactive chart data
      first_column_name <- names(data)[1]  # Get the first column name
      # Pivot data to wide format
      data <- pivot_wider(data, names_from = !!sym(first_column_name), values_from = Value)
      # Format numeric columns
      data <- data %>% mutate(across(where(is.numeric), ~ formatC(.x, format = "f", digits = 5)))
      write.csv(data, file, row.names = FALSE)  # Write data to CSV
    }
  )
}
