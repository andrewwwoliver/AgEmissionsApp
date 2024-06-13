# Source the necessary modules for server logic
source("module_data_functions.R")
source("module_chart_functions.R")

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
  
  # Create reactive chart data for each tab
  chart_data_total <- create_chart_data("Total Emissions", "year_total", "variables_total", input)
  chart_data_subsector <- create_chart_data("Subsector Emissions", "year_subsector", "variables_subsector", input)
  chart_data_gas <- create_chart_data("Gas Emissions", "year_gas", "variables_gas", input)
  
  # Render line charts for each tab
  render_line_chart("lineChart_total", chart_data_total, "Total Emissions", input, output)
  render_line_chart("lineChart_subsector", chart_data_subsector, "Subsector Emissions", input, output)
  render_line_chart("lineChart_gas", chart_data_gas, "Gas Emissions", input, output)
  
  # Render data tables for each tab
  render_data_table("pay_table_total", chart_data_total, output)
  render_data_table("pay_table_subsector", chart_data_subsector, output)
  render_data_table("pay_table_gas", chart_data_gas, output)
  
  # Handle data download for each tab
  handle_data_download("downloadData_total", "Total Emissions", chart_data_total, input, output)
  handle_data_download("downloadData_subsector", "Subsector Emissions", chart_data_subsector, input, output)
  handle_data_download("downloadData_gas", "Gas Emissions", chart_data_gas, input, output)
}
