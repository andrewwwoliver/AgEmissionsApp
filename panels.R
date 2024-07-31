# panels.R

# Function to generate the sidebar panel
generate_sidebar_panel <- function(id_prefix) {
  sidebarPanel(
    width = 3,
    uiOutput(paste0("variable_select_", id_prefix)),  # Placeholder for variable selection UI
    actionButton(paste0("select_all_button_", id_prefix), "Select All"),  # 'Select All' button
    actionButton(paste0("deselect_all_button_", id_prefix), "Deselect All"),  # 'Deselect All' button
    div(chooseSliderSkin("Flat"),
        # Slider input for selecting the year range
        sliderInput(paste0("year_", id_prefix), "Select year range", value = c(1990, 2022), min = 1990, max = 2022, step = 1, sep = "", ticks = TRUE))
  )
}







# Function to generate the main panel
generate_main_panel <- function(id_prefix, chart_type) {
  mainPanel(
    width = 9,
    tabsetPanel(
      id = paste0(id_prefix, "_tabs"),  # Add an ID to the tabsetPanel
      tabPanel("Summary Page",
               fluidRow(
                 column(width = 4, sliderInput(paste0("summary_current_year_", id_prefix), "Current Year", min = 1990, max = 2022, value = 2022, step = 1)),
                 column(width = 4, sliderInput(paste0("summary_comparison_year_", id_prefix), "Comparison Year", min = 1990, max = 2022, value = 2021, step = 1))
               ),
               fluidRow(
                 column(width = 12, div(class = "header-text", "Top 3 Categories:"))
               ),
               generate_top_industries(id_prefix),
               fluidRow(
                 column(width = 12, div(class = "header-text", "Summary Analysis:"))
               ),
               generate_summary_bottom_row(id_prefix, chart_type)
      ),
      tabPanel("Bar Chart", barChartUI(paste0("barChart_", id_prefix))),  # Bar chart tab
      tabPanel("Line Chart", lineChartUI(paste0("lineChart_", id_prefix))),  # Line chart tab
      tabPanel("Area Chart", areaChartUI(paste0("areaChart_", id_prefix))),  # Area chart tab
      tabPanel("Data Table",
               dataTableOutput(paste0("pay_table_", id_prefix)),  # Data table output
               downloadButton(paste0("downloadData_", id_prefix), "Download Data")  # Download button
      )
    )
  )
}

# Function to generate the layout by combining sidebar and main panel
generate_sidebar_layout <- function(id_prefix, chart_type) {
  sidebarLayout(
    generate_sidebar_panel(id_prefix),  # Generate sidebar panel
    generate_main_panel(id_prefix, chart_type)  # Generate main panel
  )
}
