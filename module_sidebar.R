# Function to generate the sidebar panel
generate_sidebar_panel <- function(id_prefix) {
  div(
    id = paste0("sidebar_", id_prefix),
    sidebarPanel(
      width = 3,
      uiOutput(paste0("variable_select_", id_prefix)),  # Placeholder for variable selection UI
      actionButton(paste0("select_all_button_", id_prefix), "Select All"),  # 'Select All' button
      actionButton(paste0("deselect_all_button_", id_prefix), "Deselect All"),  # 'Deselect All' button
      div(chooseSliderSkin("Flat"),
          # Slider input for selecting the year range
          sliderInput(paste0("year_", id_prefix), "Select year range", value = c(1990, 2023), min = 1990, max = 2023, step = 1, sep = "", ticks = TRUE))
    )
  )
}

# Function to generate the main panel
generate_main_panel <- function(id_prefix) {
  div(
    id = paste0("main_", id_prefix),
    mainPanel(
      width = 9,
      tabsetPanel(
        tabPanel("Bar Chart", barChartUI(paste0("barChart_", id_prefix))),  # Bar chart tab
        tabPanel("Line Chart", lineChartUI(paste0("lineChart_", id_prefix))),  # Line chart tab
        tabPanel("Area Chart", areaChartUI(paste0("areaChart_", id_prefix))),  # Area chart tab
        tabPanel("Data Table", 
                 dataTableOutput(paste0("pay_table_", id_prefix)),  # Data table output
                 downloadButton(paste0("downloadData_", id_prefix), "Download Data")  # Download button
        )
      )
    )
  )
}

# Function to generate the sidebar layout for each tab
generate_sidebar_layout <- function(id_prefix) {
  sidebarLayout(
    generate_sidebar_panel(id_prefix),  # Generate sidebar panel
    generate_main_panel(id_prefix)  # Generate main panel
  )
}
