#Show where the sources come from

source("module_sidebar.R")
source("module_line_chart.R")
source("module_data_table.R")
source("options.R")
source("module_area_chart.R")
source("module_bar_chart.R")

# Generate the UI
ui <- fluidPage(
  theme = shinytheme("flatly"),  # Apply a shiny theme
  navbarPage(
    title = "Agricultural Emissions",
    id = "navbar",
    # Create tabs for each emissions type
    tabPanel("Total Emissions", value = "total", generate_sidebar_layout("total")),
    tabPanel("Subsector Emissions", value = "subsector", generate_sidebar_layout("subsector")),
    tabPanel("Gas Emissions", value = "gas", generate_sidebar_layout("gas"))
  )
)
