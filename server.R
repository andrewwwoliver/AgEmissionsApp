##server.R
# Source the necessary modules for server logic
source("module_data_functions.R")
source("module_chart_functions.R")
source("module_bar_chart.R")
source("module_data_table.R")

# Function to setup the server logic for each tab
setup_tab <- function(tab_prefix, chart_type, input, output, session) {
  # Create reactive chart data
  chart_data <- reactive({
    create_chart_data(chart_type, paste0("year_", tab_prefix), paste0("variables_", tab_prefix), input)
  })
  
  # Render line chart
  render_line_chart(paste0("lineChart_", tab_prefix), chart_data, chart_type, input, output)
  
  # Render area chart
  render_area_chart(paste0("areaChart_", tab_prefix), chart_data, chart_type, input, output)
  
  # Render data table
  render_data_table(paste0("pay_table_", tab_prefix), chart_data, output)
  
  # Handle data download
  handle_data_download(paste0("downloadData_", tab_prefix), chart_type, chart_data, input, output, paste0("year_", tab_prefix))
  
  # Render bar chart
  barChartServer(paste0("barChart_", tab_prefix), chart_data, chart_type, input, output)
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
  
  # Reset sidebar inputs when "Bar Chart" tab is selected and hide sidebar
  observeEvent(input$reset_sidebar, {
    if (!is.null(variables())) {
      updateCheckboxGroupInput(session, "variables_total", selected = setdiff(variables(), "Total"))
      updateSliderInput(session, "year_total", value = c(1990, 2023))
      updateCheckboxGroupInput(session, "variables_subsector", selected = setdiff(variables(), "Total"))
      updateSliderInput(session, "year_subsector", value = c(1990, 2023))
      updateCheckboxGroupInput(session, "variables_gas", selected = setdiff(variables(), "Total"))
      updateSliderInput(session, "year_gas", value = c(1990, 2023))
    }
  })
  
  # Trigger the reset for the initial selection of "Bar Chart" tab
  observe({
    if (input$navbar == "total") {  # Adjust based on the initial tab
      shinyjs::runjs("
        $('.sidebar').show();
        $('.main-panel').removeClass('full-width').addClass('col-sm-9');
      ")
    }
  })
}
