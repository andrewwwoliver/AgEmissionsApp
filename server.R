# Source the necessary modules for server logic
source("module_data_functions.R")
source("module_chart_functions.R")
source("module_bar_chart.R")

# Function to setup the server logic for each tab
setup_tab <- function(tab_prefix, chart_type, input, output, session) {
  # Create reactive chart data
  chart_data <- reactive({
    create_chart_data(chart_type, paste0("year_", tab_prefix), paste0("variables_", tab_prefix), input)
  })
  
  # Industry colors (assuming these are consistent across datasets)
  industry_colors <- list(
    "Transport" = "#1f77b4",
    "Electricity Generation" = "#ff7f0e",
    "Industry" = "#2ca02c",
    "Buildings" = "#d62728",
    "Agriculture" = "#9467bd",
    "Waste Management" = "#8c564b",
    "LULUCF" = "#e377c2"
  )
  
  # Render line chart
  render_line_chart(paste0("lineChart_", tab_prefix), chart_data, chart_type, input, output)
  
  # Render area chart
  render_area_chart(paste0("areaChart_", tab_prefix), chart_data, chart_type, input, output)
  
  # Render data table
  render_data_table(paste0("pay_table_", tab_prefix), chart_data, output)
  
  # Handle data download
  handle_data_download(paste0("downloadData_", tab_prefix), chart_type, chart_data, input, output)
  
  # Render bar chart
  barChartServer(paste0("barChart_", tab_prefix), chart_data(), industry_colors)
}

# Set up server
server <- function(input, output, session) {
  # Reactive for chart type based on selected tab
  chart_type <- reactive({
    switch(input$navbar,
           "total" = "Total Emissions",
           "subsector" = "Subsector Emissions",
           "gas" = "Gas Emissions")
  })
  
  # Reactive for variables based on chart type
  variables <- reactive({
    unique(get_variables(chart_type())[[1]])  # First column is the variable column
  })
  
  # Handle variable select and button events for each tab
  lapply(c("total", "subsector", "gas"), function(prefix) {
    handle_variable_select_and_buttons(prefix, variables, input, output, session)
  })
  
  # Set up tabs
  tabs <- list(
    total = "Total Emissions",
    subsector = "Subsector Emissions",
    gas = "Gas Emissions"
  )
  
  # Set up each tab using the setup_tab function
  lapply(names(tabs), function(prefix) {
    setup_tab(prefix, tabs[[prefix]], input, output, session)
  })
}
