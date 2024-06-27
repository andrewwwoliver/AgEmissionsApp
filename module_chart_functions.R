# module_chart_functions.R

# Function to render line charts
render_line_chart <- function(chart_id, chart_data, chart_type, input, output) {
  # Create reactive for the first column name of the data
  column_name <- reactive({ names(chart_data())[1] })
  
  # Create reactive for the chart title
  title <- reactive({
    switch(chart_type,
           "Total Emissions" = paste("National Greenhouse Gas Emissions by Source in Scotland"),
           "Subsector Emissions" = paste("Agricultural Greenhouse Gas Emissions by Subsector in Scotland"),
           "Gas Emissions" = paste("Agricultural Greenhouse Gas Emissions Breakdown in Scotland")
    )
  })
  
  # Create reactive for the y-axis title based on chart type
  yAxisTitle <- reactive({
    switch(chart_type,
           "Total Emissions" = "Emissions (MtCO₂e)",
           "Subsector Emissions" = "Emissions (MtCO₂e)",
           "Gas Emissions" = "Emissions (MtCO₂e)")
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
    switch(chart_type,
           "Total Emissions" = paste("National Greenhouse Gas Emissions by Source in Scotland"),
           "Subsector Emissions" = paste("Agricultural Greenhouse Gas Emissions by Subsector in Scotland"),
           "Gas Emissions" = paste("Agricultural Greenhouse Gas Emissions Breakdown in Scotland")
    )
  })
  
  # Create reactive for the y-axis title based on chart type
  yAxisTitle <- reactive({
    switch(chart_type,
           "Total Emissions" = "Emissions (MtCO₂e)",
           "Subsector Emissions" = "Emissions (MtCO₂e)",
           "Gas Emissions" = "Emissions (MtCO₂e)")
  })
  
  # Call the server function for the area chart module
  areaChartServer(chart_id, chart_data, column_name, title, yAxisTitle)
}

# Function to render bar charts
render_bar_chart <- function(chart_id, chart_data, chart_type, input, output) {
  column_name <- reactive({ names(chart_data())[1] })
  # Create reactive for the chart title
  title <- reactive({
    switch(chart_type,
           "Total Emissions" = paste("National Greenhouse Gas Emissions Timelapse"),
           "Subsector Emissions" = paste("Agricultural Greenhouse Gas Emissions Timelapse"),
           "Gas Emissions" = paste("Agricultural Greenhouse Gas Emissions Breakdown Timelapse")
    )
  })
  yAxisTitle <- reactive({
    switch(chart_type,
           "Total Emissions" = "Emissions (MtCO₂e)",
           "Subsector Emissions" = "Emissions (MtCO₂e)",
           "Gas Emissions" = "Emissions (MtCO₂e)")
  })
  barChartServer(chart_id, chart_data, column_name, title, yAxisTitle)
}