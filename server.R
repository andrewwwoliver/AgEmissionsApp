#server.R

# Source the necessary modules for server logic
source("module_data_functions.R")
source("module_chart_functions.R")
source("module_bar_chart.R")
source("module_data_table.R")
source("module_summary.R")

# Function to reset the year range slider when Bar Chart tab is selected
reset_year_range_slider <- function(tab_prefix, input, session) {
  observeEvent(input[[paste0(tab_prefix, "_tabs")]], {
    if (input[[paste0(tab_prefix, "_tabs")]] == paste0(tab_prefix, "_bar")) {
      updateSliderInput(session, paste0("year_", tab_prefix), value = c(1990, 2022))
    }
  })
}

# List of sidebar IDs
sidebar_ids <- c("sidebar_total", "sidebar_subsector", "sidebar_gas")

# Define a function to show and then hide the sidebars
toggle_sidebars <- function(ids, delay_time = 100) {
  lapply(ids, shinyjs::show)
  shinyjs::delay(delay_time, {
    lapply(ids, shinyjs::hide)
  })
}



setup_tab <- function(tab_prefix, chart_type, input, output, session) {
  # Create reactive chart data based on sidebar inputs
  chart_data <- reactive({
    create_chart_data(chart_type, paste0("year_", tab_prefix), paste0("variables_", tab_prefix), input)
  })
  
  # Get the first column name dynamically
  first_col_name <- reactive({
    names(chart_data())[1]
  })
  
  # Get the entire dataset without filtering based on sidebar inputs for summary page
  full_data <- reactive({
    get_variables(chart_type)
  })
  
  # Render line chart with filtering for the "total" tab
  if (chart_type == "Total Emissions") {
    filtered_data <- reactive({
      full_data() %>% filter(!!sym(first_col_name()) %in% c("Agriculture", "Total"))
    })
    summaryLineChartServer(paste0("industryLineChart_", tab_prefix), filtered_data)
  } else {
    summaryPieChartServer(paste0("industryPieChart_", tab_prefix), full_data, current_year, first_col_name)
  }
  
  # Render other charts
  render_line_chart(paste0("lineChart_", tab_prefix), chart_data, chart_type, input, output)
  render_area_chart(paste0("areaChart_", tab_prefix), chart_data, chart_type, input, output)
  render_data_table(paste0("pay_table_", tab_prefix), chart_data, output)
  handle_data_download(paste0("downloadData_", tab_prefix), chart_type, chart_data, input, output, paste0("year_", tab_prefix))
  render_bar_chart(paste0("barChart_", tab_prefix), chart_data, chart_type, input, output)
  
  # Render summary page
  current_year <- reactive({ input[[paste0("summary_current_year_", tab_prefix)]] })
  comparison_year <- reactive({ input[[paste0("summary_comparison_year_", tab_prefix)]] })
  
  valueBoxServer(paste0("totalIndustry1_", tab_prefix), full_data, first_col_name, get_industry(1, full_data, current_year, first_col_name), current_year, comparison_year)
  valueBoxServer(paste0("totalIndustry2_", tab_prefix), full_data, first_col_name, get_industry(2, full_data, current_year, first_col_name), current_year, comparison_year)
  valueBoxServer(paste0("totalIndustry3_", tab_prefix), full_data, first_col_name, get_industry(3, full_data, current_year, first_col_name), current_year, comparison_year)
  valueBoxServer(paste0("totalValue_", tab_prefix), full_data, first_col_name, reactive("Total"), current_year, comparison_year)
  
  summaryBarChartServer(paste0("industryBarChart_", tab_prefix), full_data, current_year, comparison_year, first_col_name)
  
  # Reset year range slider when bar chart tab is selected
  reset_year_range_slider(tab_prefix, input, session)
  
  # Control sidebar state based on selected tab within the section
  observeEvent(input[[paste0(tab_prefix, "_tabs")]], {
    if (input[[paste0(tab_prefix, "_tabs")]] == paste0(tab_prefix, "_summary")) {
      session$sendCustomMessage(type = 'sidebarState', message = 'close')
    } else {
      session$sendCustomMessage(type = 'sidebarState', message = 'open')
    }
  })
}


# Function to get top industries
get_industry <- function(index, data, current_year, first_col_name) {
  reactive({
    industries <- data() %>%
      filter(Year == current_year() & !!sym(first_col_name()) != "Total") %>%
      group_by(!!sym(first_col_name())) %>%
      summarise(Value = sum(Value, na.rm = TRUE)) %>%
      arrange(desc(Value)) %>%
      slice_head(n = 3) %>%
      pull(!!sym(first_col_name()))
    if (length(industries) >= index) {
      industries[index]
    } else {
      NA
    }
  })
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
  
  
  # Ensure all variables except "Total" are selected for the charts
  observe({
    lapply(c("total", "subsector", "gas"), function(prefix) {
      if (input$navbar == prefix) {
        updateCheckboxGroupInput(session, paste0("variables_", prefix), selected = setdiff(variables(), "Total"))
      }
    })
  })
  
# hide on summary page
  observeEvent(input$navbar, {
    lapply(names(tabs), function(prefix) {
      observeEvent(input[[paste0(prefix, "_tabs")]], {
        if (input[[paste0(prefix, "_tabs")]] == paste0(prefix, "_summary")) {
          session$sendCustomMessage(type = 'sidebarState', message = 'close')
        } else {
          session$sendCustomMessage(type = 'sidebarState', message = 'open')
        }
      })
    })
  })
  
  # Toggle sidebar button
  observeEvent(input$toggleSidebar, {
    session$sendCustomMessage(type = 'toggleSidebar', message = NULL)
  })
  
  # Reset to summary page
  observeEvent(input$navbar, {
    updateTabsetPanel(session, "subsector_tabs", selected = "subsector_summary")
    updateTabsetPanel(session, "total_tabs", selected = "total_summary")
    updateTabsetPanel(session, "gas_tabs", selected = "gas_summary")
  })
  # Ensure sidebar loads correctly
  observeEvent(input$navbar, {
    # Call the toggle_sidebars function
    toggle_sidebars(sidebar_ids)
    
    # Update the tabset panel based on the selected navbar
    tabset_panel_id <- switch(input$navbar,
                              "total" = "total_tabs",
                              "gas" = "gas_tabs",
                              "subsector" = "subsector_tabs")
    selected_tab <- paste0(input$navbar, "_summary")
    updateTabsetPanel(session, tabset_panel_id, selected = selected_tab)
  })
  
}


