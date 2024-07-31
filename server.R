# server.R

# Source the necessary modules for server logic

source("module_summary.R")

#module_data_functions.R

# Function to get data based on the chart type
get_variables <- function(chart_type) {
  switch(chart_type,
         "Total Emissions" = national_total,
         "Subsector Emissions" = subsector_total,
         "Gas Emissions" = agri_gas)
}

# Function to create reactive chart data based on user inputs
create_chart_data <- function(chart_type, year_input, variables_input, input) {
  data <- get_variables(chart_type)
  first_col_name <- names(data)[1]
  data %>%  filter(!!sym(first_col_name) %in% input[[variables_input]])
}

# Preset list of colors
preset_colors <- c("#002d54", "#2b9c93", "#6a2063", "#e5682a", "#0b4c0b", "#5d9f3c", "#592c20", "#ca72a2")

# Function to assign colors to variables
assign_colors <- function(data, colors) {
  first_col_name <- names(data)[1]
  variables <- unique(data[[first_col_name]])
  setNames(colors[1:length(variables)], variables)
}




# Function to setup the server logic for each tab
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
  
  # Render summary page
  current_year <- reactive({ input[[paste0("summary_current_year_", tab_prefix)]] })
  comparison_year <- reactive({ input[[paste0("summary_comparison_year_", tab_prefix)]] })
  
  valueBoxServer(paste0("totalIndustry1_", tab_prefix), full_data, first_col_name, get_industry(1, full_data, current_year, first_col_name), current_year, comparison_year)
  valueBoxServer(paste0("totalIndustry2_", tab_prefix), full_data, first_col_name, get_industry(2, full_data, current_year, first_col_name), current_year, comparison_year)
  valueBoxServer(paste0("totalIndustry3_", tab_prefix), full_data, first_col_name, get_industry(3, full_data, current_year, first_col_name), current_year, comparison_year)
  valueBoxServer(paste0("totalValue_", tab_prefix), full_data, first_col_name, reactive("Total"), current_year, comparison_year)
  summaryPieChartServer(paste0("industryPieChart_", tab_prefix), full_data, current_year, first_col_name)
  summaryBarChartServer(paste0("industryBarChart_", tab_prefix), full_data, current_year, comparison_year, first_col_name)
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


