#module_chart_functions.R

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
