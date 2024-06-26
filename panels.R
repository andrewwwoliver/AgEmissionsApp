# panels.R

# Function to generate the value boxes for the top 3 industries
generate_top_industries <- function(id_prefix) {
  fluidRow(
    column(width = 4, valueBoxUI(paste0("totalIndustry1_", id_prefix)), style = "padding-right: 0; padding-left: 0;"),
    column(width = 4, valueBoxUI(paste0("totalIndustry2_", id_prefix)), style = "padding-right: 0; padding-left: 0;"),
    column(width = 4, valueBoxUI(paste0("totalIndustry3_", id_prefix)), style = "padding-right: 0; padding-left: 0;")
  )
}

# Function to generate the bottom row of the summary page
generate_summary_bottom_row <- function(id_prefix, chart_type) {
  fluidRow(
    column(width = 4, valueBoxUI(paste0("totalValue_", id_prefix)), style = "padding-right: 0; padding-left: 0;"),
    column(width = 4,
           if (chart_type == "Total Emissions") {
             chartUI(paste0("industryLineChart_", id_prefix), "Industry Emissions Over Time")
           } else {
             chartUI(paste0("industryPieChart_", id_prefix), "Category Breakdown")
           },
           style = "padding-right: 0; padding-left: 0;"
    ),
    column(width = 4, chartUI(paste0("industryBarChart_", id_prefix), "Emissions by Category"), style = "padding-right: 0; padding-left: 0;")
  )
}

# Function to generate the sidebar layout for each tab
generate_sidebar_layout <- function(id_prefix, chart_type) {
  sidebarLayout(
    sidebarPanel(
      width = 3,
      uiOutput(paste0("variable_select_", id_prefix)),  # Placeholder for variable selection UI
      actionButton(paste0("select_all_button_", id_prefix), "Select All"),  # 'Select All' button
      actionButton(paste0("deselect_all_button_", id_prefix), "Deselect All"),  # 'Deselect All' button
      div(chooseSliderSkin("Flat"),
          # Slider input for selecting the year range
          sliderInput(paste0("year_", id_prefix), "Select year range", value = c(1990, 2022), min = 1990, max = 2022, step = 1, sep = "", ticks = TRUE))
    ),
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
  )
}
