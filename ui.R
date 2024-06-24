#ui.R

# Source UI modules
source("panels.R")
source("module_line_chart.R")
source("module_data_table.R")
source("options.R")
source("module_area_chart.R")
source("module_bar_chart.R")
source("module_summary.R")

# Generate the UI
ui <- fluidPage(
  theme = shinytheme("flatly"),  # Apply a shiny theme
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")
  ),
  div(class = "container-fluid full-height",  # Ensure the full height of the container
      navbarPage(
        title = div(
          div("Agricultural Emissions Dashboard", style = "flex-grow: 1;"),
          img(src = "RESAS Logo.png", class = "header-logo")  # Add logo 
        ),
        id = "navbar",
        tabPanel("Agriculture Emissions", value = "subsector", generate_sidebar_layout("subsector")),
        tabPanel("Industry Emissions", value = "total", generate_sidebar_layout("total")),
        tabPanel("Gas Emissions", value = "gas", generate_sidebar_layout("gas"))
      )
  )
)
